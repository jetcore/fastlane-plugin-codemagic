require 'fastlane_core/ui/ui'

describe Fastlane::Actions::CodemagicAction do
  describe '#get_post_payload' do
    it 'should return a valid json payload' do
      app_id = "YOUR_APP_ID"
      workflow_id = "YOUR_WORKFLOW_ID"
      branch = "master"
      environment = {
          variables: {
              ENV: "production"
          },
          softwareVersions: {
              flutter: "stable",
              xcode: "latest",
              cocoapods: "default"
          }
      }

      result = Fastlane::Actions::CodemagicAction.get_post_payload(app_id, workflow_id, branch, environment)

      expected_payload = "{\"appId\":\"YOUR_APP_ID\",\"workflowId\":\"YOUR_WORKFLOW_ID\",\"branch\":\"master\",\"environment\":{\"variables\":{\"ENV\":\"production\"},\"softwareVersions\":{\"flutter\":\"stable\",\"xcode\":\"latest\",\"cocoapods\":\"default\"}}}"
      expect(result).to eq(expected_payload)
    end
  end
end
