require 'notifier'
require 'message_finder'
require 'mysql_interface'

class DelayedJobTracer
  
  def self.run
    c = YAML.load_file(File.join(File.dirname(__FILE__), *%w[.. .. .. .. config delayed_job_tracer_config.yml]))
    Notifier.notify_admin_of_email_issue unless MessageFinder.found_recent_message?
    Notifier.notify_admin_of_queue_issue unless MySQLInterface.delayed_job_queue_ok?
    MySQLInterface.queue_delayed_job
  end
  
end