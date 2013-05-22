# -*- encoding: utf-8 -*-
module DeployTweet
  def deploy_tweet
    update "revision #{revision} deployed!"
  end
end
