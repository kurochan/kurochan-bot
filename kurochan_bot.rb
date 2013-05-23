# -*- encoding: utf-8 -*-

class KurochanBot < TwitterBot
  def initialize
    super
    require_plugin 'deploy_tweet'
    require_plugin 'yoruho'
    init_task
    job :intval => 3.seconds, :func => :hello
    job :intval => 5.minutes, :func => :normal_task
    job :intval => 1.day, :func => :yoruho, :at => '00:00'
  end

  def init_task
    rev = revision
    unless rev == deploy_time
      deploy_tweet
      self.deploy_time = rev
    end
  end

  def normal_task
  end
end
