# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "delayed_job_tracer/version"

Gem::Specification.new do |s|
  s.name        = "delayed_job_tracer"
  s.version     = DelayedJobTracer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Kenny Johnston"]
  s.email       = ["kjohnston.ca@gmail.com"]
  s.homepage    = "https://github.com/kjohnston/delayed_job_tracer"
  s.summary     = %q{Like a tracer bullet for your delayed_job queue}
  s.description = %q{Monitors the delayed_job queue and periodically tests its ability to deliver 
                     e-mail messages and e-mails you if something goes wrong, such as the delayed_job 
                     process crashes or one of its jobs fails or takes too long to complete.}

  s.add_dependency('tmail', '1.2.7.1')
  s.add_dependency('mms2r', '2.4.1')
  s.add_dependency('mysql2', '0.2.6')

  s.files              = `git ls-files`.split("\n")
  s.test_files         = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables        = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths      = ["lib"]
end
