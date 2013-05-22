# -*- encoding: utf-8 -*-

class KurochanBot < TwitterBot
  def initialize
    super
    require_plugin 'deploy_tweet'
    init_task
    job :intval => 3.seconds, :func => :hello
    job :intval => 5.minutes, :func => :normal_task
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
