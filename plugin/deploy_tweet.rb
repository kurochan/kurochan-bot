module DeployTweet
  def deploy_tweet
    update "deploy! version #{self.deploy_time}!"
    self.deploy_time += 1
  end
end
