module DeployTweet
  def deploy_tweet
    update "revision #{revision} deployed!"
  end
end
