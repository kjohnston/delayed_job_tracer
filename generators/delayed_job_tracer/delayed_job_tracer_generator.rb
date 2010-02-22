class DelayedJobTracerGenerator < Rails::Generator::Base
  
  attr_accessor :app_name, 
                :db_host, :db_database, :db_username, :db_password,
                :mail_domain, :mail_username, :mail_password
  
  def manifest
    @app_name = Dir.glob(RAILS_ROOT).to_s.split('/').last
    
    db_config      = Rails::Configuration.new
    @db_host       = db_config.database_configuration["production"]["host"]
    @db_database   = db_config.database_configuration["production"]["database"]
    @db_username   = db_config.database_configuration["production"]["username"]
    @db_password   = db_config.database_configuration["production"]["password"]
    
    mail_config    = ActionMailer::Base.smtp_settings
    @mail_domain   = mail_config[:address]
    @mail_username = mail_config[:user_name]
    @mail_password = mail_config[:password]
    
    record do |m|
      m.template 'delayed_job_tracer_config.yml', File.join('config', 'delayed_job_tracer_config.yml')
    end
  end
  
end