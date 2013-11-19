# -*- encoding: utf-8 -*-
class KurochanBot < TwitterBot
  def initialize
    super
    require_plugin 'deploy_tweet'
    require_plugin 'heroku_helper'
    require_plugin 'reply'
    require_plugin 'yoruho'
    require_plugin 'keyword_fav'
    init_task
    # job :intval => 3.seconds, :func => :hello
    job :intval => 5.minutes, :func => :normal_task
    job :intval => 1.day, :func => :yoruho, :at => '00:00'
  end

  def init_task
    rev = heroku_revision || 0
    unless rev == deploy_time
      deploy_tweet rev
      self.deploy_time = rev
    end
  end

  def normal_task
  end

  def on_status(status)
    # keyword_fav status
  end

  def on_reply_status(status)
    default_reply
  end
end
