require 'rubygems'
require 'net/imap'
require 'tmail'
require 'mms2r'
require 'yaml'

class MessageFinder

  def self.found_recent_message?
    c = DelayedJobTracer.config['monitor']

    server   = c['server']
    port     = c['port'] || 143
    ssl      = c['ssl'] || false
    username = c['username']
    password = c['password']
    folder   = c['folder']

    imap = Net::IMAP.new server, port, ssl
    imap.login username, password
    imap.select folder
    uids = imap.search(["UNSEEN"])

    emails = []
    times = []

    uids.each do |uid|
      mdata = imap.fetch(uid, 'RFC822')[0].attr['RFC822']
      tmail = TMail::Mail.parse mdata
      mms   = MMS2R::Media.new tmail
      emails << {:mdata => mdata, :tmail => tmail, :mms => mms, :uid => uid}
    end

    emails.each do |email|
      # Collects the dates of unread messages
      times << email[:tmail].date
      # Marks unread messages as read
      imap.store email[:uid], "+FLAGS", [:Seen]
    end

    imap.disconnect

    # Delete tmp files used by mms2r
    emails.map{|m| m[:mms].purge }

    # Just checks to see if there was at least one recent unread message
    return true unless times.blank?
  end

end