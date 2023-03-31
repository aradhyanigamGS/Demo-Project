# frozen_string_literal: true

# Model to store all Tickets.
class Ticket < ApplicationRecord
  include AASM
  has_many :sprint_tickets
  has_many :sprints, through: :sprint_tickets, dependent: :destroy

  aasm column: 'status', whiny_transitions: false do
    state :to_do, initial: true
    state :doing
    state :testing
    state :done

    after_all_transitions :log_status_change

    event :start do
      transitions from: %i[to_do testing], to: :doing
    end
    event :test do
      transitions from: :doing, to: :testing
    end
    event :done do
      transitions from: :testing, to: :done
    end
    event :reset do
      transitions from: %i[doing testing], to: :to_do
    end
  end

  def log_status_change
    puts "changing from #{aasm.from_state} to #{aasm.to_state}"
  end
end
