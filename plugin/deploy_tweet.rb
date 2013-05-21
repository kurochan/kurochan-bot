module DeployTweet
  def deploy_tweet
    update "version #{self.deploy_time} deployed!"
    self.deploy_time += 1
  end
end
