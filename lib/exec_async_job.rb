# frozen_string_literal: true

class ExecAsyncJob
  include Sidekiq::Job
  # sidekiq_options queue: :priority

  def perform(class_name, id, method, args = [])
    Rails
      .logger
      .debug("Exec async #{class_name}##{method}(#{id}) with args: #{args}")

    target_class = class_name.constantize
    target = id == "class_method" ? target_class : target_class.find_by(id: id)

    return unless target # could be non-existing at this point

    args.present? ? target.send(method, *args) : target.send(method)
  end
end
