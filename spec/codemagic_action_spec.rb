describe Fastlane::Actions::CodemagicAction do
  describe '#run' do
    it 'prints a message' do
      #expect(Fastlane::UI).to receive(:message).with("The codemagic plugin is working!")
      Fastlane::Actions::CodemagicAction.run({ "appId" => "appId" })
    end
  end
end
