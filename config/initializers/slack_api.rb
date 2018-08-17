require 'slack'

Slack.configure do |config|
  config.token = "SLACK_TOKEN"
end

Slack.auth_test
