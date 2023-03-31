# frozen_string_literal: true

# Model to store all Sprints.
class SprintsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_by_slug, only: %i[show new create end_sprint backlog_tickets]
  before_action :new_sprint_is_present, only: %i[end_sprint]
  # def index
  #   @project = Project.friendly.find_by_slug(params[:project_slug])
  #   @board = @project.board
  #   @sprints = Sprint.all
  # end

  def show
    @sprint = Sprint.friendly.find_by_slug(params[:slug])
    return unless @sprint.nil?

    raise ActiveRecord::RecordNotFound
  end

  def new
    @sprint = Sprint.new
  end

  def create
    @sprint = @board.sprints.create(sprint_params)

    if @sprint.save
      redirect_to project_board_sprint_path(slug: @sprint)
    else
      render :new
    end
  end

  def end_sprint
    # before action working for the method
  end

  def select_sprint
    @previous_sprint = Sprint.friendly.find_by_slug(params[:sprint_slug])
    @current_sprint = Sprint.friendly.find_by_slug(params[:slug])
    @tickets = []
    @previous_sprint.tickets.each do |ticket|
      # debugger
      if ticket.status != 'done'
        @tickets << ticket
      end
    end
    @tickets.each do |ticket|
      @current_sprint.sprint_tickets.create(ticket: ticket)
      ticket.reset!
    end
    update_state
    redirect_to project_board_sprint_path(slug: params[:slug ])
  end

  def backlog_tickets
    @sprint = Sprint.friendly.find_by_slug(params[:slug])
  end

  private

  def find_by_slug
    @project = current_user.projects.friendly.find_by_slug(params[:project_slug])
    @board = @project.board
    @sprint = Sprint.friendly.find_by_slug(params[:slug])
  end

  def sprint_params
    params.require(:sprint).permit(:name, :start_time, :goal, :duration)
  end

  def update_state
    @previous_sprint.current_sprint = false
    @previous_sprint.save
    @current_sprint.current_sprint = true
    @current_sprint.save
  end

  def new_sprint_is_present
    is_present = false
    @tickets = []
    @board.sprints.each do |sprint|
      if sprint.current_sprint.nil? && sprint.backlog_sprint.nil?
        is_present = true
      end
    end
    if is_present
    else
      redirect_to new_project_board_sprint_path(board_slug: @board), alert: 'No sprint to transfer tickets to, Create a ticket first then try again!'
    end
  end
end
