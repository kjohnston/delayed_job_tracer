if defined?(ActionMailer)
  require File.dirname(__FILE__) + '/delayed_job_tracer/delayed_job_tracer_mailer.rb'
else
  require File.dirname(__FILE__) + '/delayed_job_tracer/notifier'
  require File.dirname(__FILE__) + '/delayed_job_tracer/message_finder'
  require File.dirname(__FILE__) + '/delayed_job_tracer/mysql_interface'

  class DelayedJobTracer

    def self.config
      @@config
    end

    def self.config=(c)
      @@config = c
    end

    def self.run(config)
      @@config = config
      Notifier.notify_admin_of_email_issue unless MessageFinder.found_recent_message?
      Notifier.notify_admin_of_queue_issue unless MySQLInterface.delayed_job_queue_ok?
      MySQLInterface.queue_delayed_job
    end

  end
end