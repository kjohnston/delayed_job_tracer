# delayed_job_tracer

The delayed_job_tracer gem is designed to monitor the delayed_job gem ([https://github.com/collectiveidea/delayed_job](https://github.com/collectiveidea/delayed_job)).  It will alert you via e-mail if something goes wrong, such as if the delayed_job process crashes or one of its jobs fails or takes too long to complete.

This gem also detects wither e-mails sent through delayed_job are actually being delivered by sending test messages (like tracer bullets) to an e-mail account then checking that account to ensure they were processed and dispatched via the delayed_job queue.  The e-mail delivery detection allows you to be notified if e-mails can't be sent out either because of delayed_job having choked or because of an issue with the e-mail account the application uses to send e-mail.


## Primary Features

* Sends an e-mail notification when delayed_job crashes or is unable to complete a job in a reasonable amount of time.
* Sends an e-mail notification when the Rails application is unable to successfully deliver e-mails via delayed_job.
* Circumvents the need for a process monitoring tool like Monit or God for delayed_job processes.
* Keeps memory usage low by working outside of Rails.


## Rails and delayed_job support

* The master branch and all 1.x series gems work with delayed_job 2.1.x and above (Rails 3.x)
* The 2-3-stable branch and all 0.9.x series gems work with delayed_job 2.0.7 and above (Rails 2.3)


## Why use a Cron'd ruby process to monitor delayed_job and e-mail delivery?

* Cron is often considered to be more reliable than process monitoring tools like Monit or God.
* The Cron'd Ruby process only uses a modest amount of memory (~27MB) for a few seconds at regular intervals, whereas a rake task or runner would equate to the entire size of the Rails application, with a memory footprint that grows over time.


## Why use a Perl Script to send alert e-mails to admins?

* It's fast
* It doesn't rely on the Rails application
* It doesn't rely on the delayed_job process you're monitoring with this gem


## Prerequisites

1) Install XML and SSL Packages:

Note: These are for Ubuntu.  You may need to find alternate packages for your platform.

  sudo apt-get install libxml2-dev libxslt-dev libnet-ssleay-perl libcrypt-ssleay-perl libio-socket-ssl-perl

2) sendEmail Perl script:

Download from [http://caspian.dotconf.net/menu/Software/SendEmail](http://caspian.dotconf.net/menu/Software/SendEmail) and follow the setup instructions, or just follow these instructions:

  wget -c http://caspian.dotconf.net/menu/Software/SendEmail/sendEmail-v1.56.tar.gz
  tar xvfz sendEmail-v1.56.tar.gz
  sudo cp -a sendEmail-v1.56/sendEmail /usr/local/bin
  chmod +x /usr/local/bin/sendEmail

Run it to be sure it works:

  sendEmail

Cleanup:

  rm -rf sendEmail-v1.56*


## Installation

1) Add the gem to your Gemfile:

  gem "delayed_job_tracer"

2) Generate the config file:

  rails g delayed_job_tracer

## Configuration

1) Create a 'DelayedJobTracer' folder/label in the e-mail account you configure the plugin to send test messages to and a filter to move all incoming messages with '[DelayedJobTracer]' in the subject line to this folder (or label if you're using Gmail).  Set the name of this folder in the config/delayed_job_tracer_config.yml file - as it will be the folder that the Ruby process checks for test messages.

2) Add a Cron job on the server:

Example for running every 15 minutes, replace with your actual app and ruby locations:

  */15 * * * * /usr/local/bin/delayed_job_tracer -c /opt/apps/appname/current/config/delayed_job_tracer_config.yml

Note: If you're using bundler to install gems within an application-specific gem environment, you may need to also install the gem manually on the server so that the executable is available via the location in the example cron entry above.

Finish configuring your settings in the config/delayed_job_tracer_config.yml file.  Your database and ActionMailer config will be applied via the generator, but you'll still need to provide an alternate e-mail account to send administrative notifications through, provide the admin's e-mail address and so forth.

## License

* Freely distributable and licensed under the [MIT license](http://kjohnston.mit-license.org/license.html).
* Copyright (c) 2010-2012 Kenny Johnston [![endorse](http://api.coderwall.com/kjohnston/endorsecount.png)](http://coderwall.com/kjohnston)
