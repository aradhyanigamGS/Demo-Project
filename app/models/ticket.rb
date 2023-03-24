class Ticket < ApplicationRecord

  include AASM

  aasm column: 'status', :whiny_transitions => false do
    state :to_do, initial: true
    state :progress
    state :QA
    state :done

    after_all_transitions :log_status_change

    event :doing do
      transitions from: [:to_do, :QA], to: :progress
    end
    event :testing do
      transitions from: [:progress], to: :QA
    end
    event :done do
      transitions from: [:QA], to: :done
    end

  end

  has_many :sprint_tickets, dependent: :destroy
  has_many :sprints, through: :sprint_tickets

  def log_status_change
    puts "changing from #{aasm.from_state} to #{aasm.to_state}"
  end
end
