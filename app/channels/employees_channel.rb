class EmployeesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "employees"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
