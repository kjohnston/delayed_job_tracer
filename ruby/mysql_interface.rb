require 'mysql'

class MySQLInterface
  
  # Connects to the db and submits a query
  def self.query(sql)
    c = YAML.load_file(File.join(File.dirname(__FILE__), *%w[.. .. .. .. config delayed_job_tracer_config.yml]))['database']
    d = Mysql::new(c['ip'], c['user'], c['password'], c['database'])
    d.query(sql)
  end
  
  # Returns true if there are no stale records
  def self.delayed_job_queue_ok?
    query(delayed_job_stale_records).num_rows.zero?
  end
  
  # Inserts a delayed_job record
  def self.queue_delayed_job
    query(delayed_job_record).to_s
  end
  
  # SQL for selecting stale delayed_job records
  def self.delayed_job_stale_records
    c = YAML.load_file(File.join(File.dirname(__FILE__), *%w[.. .. .. .. config delayed_job_tracer_config.yml]))['delayed_job']
    "SELECT * FROM delayed_jobs WHERE created_at < '#{(Time.now-c['stale']).utc.strftime("%Y-%m-%d %H:%M:%S")}'"
  end
  
  # SQL for inserting a delayed_job record
  def self.delayed_job_record
    "INSERT INTO delayed_jobs (`handler`, `run_at`, `created_at`, `updated_at`) VALUES 
      ('#{delayed_job_handler}', '#{mysql_timestamp}', '#{mysql_timestamp}', '#{mysql_timestamp}')"
  end
  
  # SQL helper method for inserting a delayed_job record
  def self.delayed_job_handler
    mailer_class = YAML.load_file(File.join(File.dirname(__FILE__), *%w[.. .. .. .. config delayed_job_tracer_config.yml]))['mailer']['class']
    "--- !ruby/struct:Delayed::PerformableMethod 
object: CLASS:#{mailer_class}
method: :deliver_delayed_job_test_message
args: []"
  end
  
  # Timestamp in the format that e-mails expect
  def self.email_timestamp
    Time.now.strftime("%a, %e %b %Y %H:%M:%S %z")
  end
  
  # Timestamp in the format that MySQL expects
  def self.mysql_timestamp
    Time.now.utc.strftime("%Y-%m-%d %H:%M:%S")
  end
  
end