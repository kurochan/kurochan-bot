module DeployTweet
  def deploy_tweet
    update "revision #{revision} deployed!" unless revision == deploy_time
    self.deploy_time = revision
  end
end
