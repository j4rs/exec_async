# frozen_string_literal: true

module ExecAsync
  extend ActiveSupport::Concern

  class_methods do
    def extract_args(context = self, method_name = nil, args)
      arity = context.method(method_name).arity

      args_size = args&.size&.to_i
      unless arity.negative? || arity === args_size
        raise "Invalid number of arguments, #{method_name} " \
              "expected #{arity} but received #{args_size}"
      end

      id =
        if context.is_a?(Class)
          'class_method'
        else
          raise "#{context} does not respond to id" unless context.respond_to?(:id)

          context.id
        end

      [name, id, method_name.to_s, args]
    end

    def exec_async(method_name, *args)
      ExecAsyncJob
        .perform_async(*extract_args(self, method_name, args))
    end

    def exec_async_in(seconds, method_name, *args)
      ExecAsyncJob
        .perform_in(seconds,
                    *extract_args(self, method_name, args))
    end
  end

  def exec_async(method_name, *args)
    ExecAsyncJob
      .perform_async(*self.class.extract_args(self, method_name, args))
  end

  def exec_async_in(seconds, method_name, *args)
    ExecAsyncJob
      .perform_in(seconds,
                  *self.class.extract_args(self, method_name, args))
  end
end
