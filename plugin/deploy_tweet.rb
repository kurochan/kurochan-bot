# -*- encoding: utf-8 -*-
module DeployTweet
  def deploy_tweet(revision)
    update "revision #{revision} deployed!"
  end
end
