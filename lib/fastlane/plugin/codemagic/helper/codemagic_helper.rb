require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class CodemagicHelper
      # class methods that you define here become available in your action
      # as `Helper::CodemagicHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the codemagic plugin helper!")
      end
      def self.validate!(params)
        if (params[:branch].nil? || params[:branch].empty?) && (params[:tag].nil? || params[:tag].empty?)
          UI.user_error!("You must provide either a branch or a tag.")
        end
      end
    end
  end
end
