# Include this module in your mailer class:
#   include DelayedJobTracerMailer

module DelayedJobTracerMailer
  
  # Delivery method called via send_later, which is simulated by direct insertion of 
  # delayed_job records by the mysql_interface class via a cron job.
  def delayed_job_test_message
    c = YAML.load_file(File.join(RAILS_ROOT, 'config', 'delayed_job_tracer_config.yml'))
    @from       = ActionMailer::Base.smtp_settings[:user_name]
    @recipients = c['monitor']['username']
    @subject    = "[Monitoring] #{Time.zone.now}"
    @sent_on    = Time.zone.now
  end
  
  # This class level method can be called on the mailer model this module is mixed into
  # via the console to generate a delayed_job record - so the handler can be copied into
  # the insert command issued by the mysql_interface class.
  module ClassMethods
    def queue_delayed_job_test_message
      self.send_later(:delayed_job_test_message)
    end
  end
  
  # This extends the mailer class this module is mixed into to include the class-level 
  # method above.
  def self.included(base)
    base.extend(ClassMethods)
  end
  
end