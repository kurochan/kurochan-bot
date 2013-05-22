module DeployTweet
  def deploy_tweet(revision)
    update "revision #{revision} deployed!"
  end
end
