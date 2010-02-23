require 'yaml'

class Notifier
    
  def self.notify_admin_of_email_issue
    subject_suffix = 'E-mail Issue'
    message_suffix = 'is having trouble sending e-mail via delayed_job, please investigate.'
    send_notification(subject_suffix, message_suffix)
  end
  
  def self.notify_admin_of_queue_issue
    subject_suffix = 'Queue Issue'
    message_suffix = 'has one or more stale delayed_jobs, please investigate.'
    send_notification(subject_suffix, message_suffix)
  end
  
  def self.send_notification(subject_suffix, message_suffix)
    c         = YAML.load_file(File.join(File.dirname(__FILE__), *%w[.. .. .. .. config delayed_job_tracer_config.yml]))
    account   = c['alert']
    recipient = c['admin']['email']
    appname   = c['app']['name']
    subject   = "[#{appname}] Delayed Job Tracer: " + subject_suffix
    message   = "#{appname} " + message_suffix
    system    "/usr/local/bin/sendEmail -f #{account['username']} -t #{recipient} -u '#{subject}' -m #{message} \
                -s #{account['server']}:#{account['port']} -xu #{account['username']} -xp #{account['password']} \
                #{ '-o tls=yes' if c['alert']['tls'] == 'true' }"
  end
  
end