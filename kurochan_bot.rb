# -*- encoding: utf-8 -*-
require "#{PLUGIN_ROOT}/twitter_bot"

class KurochanBot < TwitterBot
  def initialize
    super

    job :intval => 3.seconds, :func => :hello
  end
end
