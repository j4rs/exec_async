### Execute methods async without having to create extra classes.

Utility code (feel free to copy and paste it to your codebase) **to convert your active records or any class methods in Ruby into Sidekiq background jobs**.

Note: It is based on [Sidekiq](https://github.com/sidekiq/sidekiq) but easily adaptable to [ActiveJob](https://guides.rubyonrails.org/active_job_basics.html) or similar implementations of background processing for ruby code.

### Use

Include `ExecAsync` in your class:

```ruby
class Order < ApplicationRecord
  include ExecAsync

  def self.notify_deliveries_for_today
    # Send emails, push notifications, etc...
  end

  def ship_it(to)
    # Send messages or communicate with an API...
  end

  def track_delivery
    # Run a process that listen for ping signals...
  end
end

order = Order.find(123)
# Execute the ship_in in bg
order.exec_async :shipt_it, to: "9703 Pilgrim Street Hagerstown, MD 21740"
# Schedule (or delay) the execution for two hours
order.exec_async_in 2.hours, :track_delivery
# Customize the sidekiq job
order.exec_async_in 2.hours, :track_delivery, queue: :low_priority
```

It supports class methods too:

```ruby
Order.exec_async :notify_deliveries_for_today
```
