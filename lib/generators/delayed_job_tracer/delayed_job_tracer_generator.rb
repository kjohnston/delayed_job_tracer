require 'rails/generators'
 
class DelayedJobTracerGenerator < Rails::Generators::Base
  
  attr_accessor :app_name, :db_host, :db_database, :db_username, :db_password,
                :mail_domain, :mail_username, :mail_password
      
  def self.source_root
    @source_root ||= File.join(File.dirname(__FILE__), 'templates')
  end
      
  def create_config_file
    @app_name = Dir.glob(Rails.root).to_s.split('/').last
    
    db_config      = YAML.load_file('config/database.yml')
    @db_host       = db_config['production']['host']
    @db_database   = db_config['production']['database']
    @db_username   = db_config['production']['username']
    @db_password   = db_config['production']['password']
    
    mail_config    = ActionMailer::Base.smtp_settings
    @mail_domain   = mail_config[:address]
    @mail_username = mail_config[:user_name]
    @mail_password = mail_config[:password]
    
    template 'delayed_job_tracer_config.yml', 'config/delayed_job_tracer_config.yml'
  end
  
end