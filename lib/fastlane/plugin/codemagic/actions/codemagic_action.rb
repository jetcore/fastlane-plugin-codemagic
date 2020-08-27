module Fastlane
  module Actions
    class CodemagicAction < Action
      def self.run(params)
        UI.message("The codemagic plugin is working!")

        FastlaneCore::PrintTable.print_values(config: params.values(ask: false),
                                              hide_keys: [],
                                              title: "Codemagic options")

        json = get_post_payload(params[:app_id],
                                params[:workflow_id],
                                params[:branch],
                                params[:environment])

        params[:download] ||= {}
        params[:download][:artefacts] ||= []
        params[:download][:build_path] ||= nil

        build_path = params[:download][:build_path]
        download_artefacts = params[:download][:artefacts]

        trigger_codemagic_build(params[:auth_token], json)

        last_build_id = get_last_build_id(params[:auth_token], params[:app_id])

        build = check_building_status(params[:auth_token], last_build_id)
        unless build_path.nil?
          download_artefacts(download_artefacts, build, build_path)
        end
      end

      def self.get_post_payload(app_id, workflow_id, branch, environment)
        UI.message("Payload creation...")
        payload = {}

        unless app_id.nil?
          payload["appId"] = app_id
        end

        unless workflow_id.nil?
          payload["workflowId"] = workflow_id
        end

        unless branch.nil?
          payload["branch"] = branch
        end

        unless environment.nil?
          payload["environment"] = environment
        end

        payload.to_json
      end

      def self.trigger_codemagic_build(auth_token, json)
        UI.message("Requesting codemagic.io API...")
        uri = URI.parse("https://api.codemagic.io/builds")
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        request = Net::HTTP::Post.new(uri.path)

        request["X-Auth-Token"] = auth_token
        request["Content-Type"] = "application/json"

        request.body = json
        response = https.request(request)

        json_response = JSON.parse(response.body)

        if response.code == "200"
          UI.success("Build triggered successfully on Codemagic.io 🚀 [#{json_response}]")
        else
          UI.user_error!("Couln't trigger the build on Codemagic.io.")
          FastlaneCore::PrintTable.print_values(config: json_response,
                                                hide_keys: [],
                                                title: "Codemagic API response")
        end
      end

      def self.get_last_build_id(auth_token, app_id)
        UI.message("Requesting codemagic.io API...")
        uri = URI.parse("https://api.codemagic.io/apps/#{app_id}")
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        request = Net::HTTP::Get.new(uri.path)

        request["X-Auth-Token"] = auth_token
        request["Content-Type"] = "application/json"

        response = https.request(request)
        json_response = JSON.parse(response.body)

        if response.code == "200"
          last_build_id = json_response["application"]["lastBuildId"]
          UI.success("Get last build ID on Codemagic.io 🚀 [#{last_build_id}]")
          last_build_id
        else
          UI.user_error!("Couln't trigger the build on Codemagic.io.")
          FastlaneCore::PrintTable.print_values(config: json_response,
                                                hide_keys: [],
                                                title: "Codemagic API response")
        end
      end

      def self.check_building_status(auth_token, build_id)
        prev_build_status = ''
        loop do
          build = get_build(auth_token, build_id)
          build_status = build["status"]

          case build_status
          when "failed"
            UI.abort_with_message!(build["message"])
          when "success", "finished"
            UI.success("Success")
            return build
          else
            if prev_build_status != build_status
              UI.message("Status: #{build_status}")
            end
            prev_build_status = build_status
            sleep(10)
            next
          end
          break
        end
      end

      def self.get_build(auth_token, build_id)
        uri = URI.parse("https://api.codemagic.io/builds/#{build_id}")
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        request = Net::HTTP::Get.new(uri.path)

        request["X-Auth-Token"] = auth_token
        request["Content-Type"] = "application/json"

        response = https.request(request)

        json_response = JSON.parse(response.body)

        if response.code == "200"
          json_response["build"]
        else
          UI.user_error!("Couln't trigger the build on Codemagic.io.")
          FastlaneCore::PrintTable.print_values(config: json_response,
                                                hide_keys: [],
                                                title: "Codemagic API response")
        end
      end

      def self.download_artefacts(download_artefacts, build, build_path)
        UI.message("Download artefacts codemagic.io API...")

        artefacts = build["artefacts"]

        real_build_dir = File.expand_path(build_path)

        if Dir.exist?(real_build_dir)

          artefacts.map do |artefact|
            next unless download_artefacts.include?(artefact["type"]) || download_artefacts == 'all'

            UI.message("Download #{artefact['type']} [#{artefact['size']}]: #{artefact['url']}")

            real_build_path = File.expand_path("#{build_path}#{artefact['name']}")

            open(real_build_path, 'wb') do |file|
              file << open(artefact["url"]).read
            end
          end
        else
          UI.build_failure!("Directory not exists [#{real_build_dir}]")
        end
      end

      def self.description
        "Fastlane plugin to trigger a Codemagic build with some options"
      end

      def self.authors
        ["Mikhail Matsera"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        ""
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :app_id,
                                  env_name: "CODEMAGIC_APP_ID",
                               description: "Codemagic application identifier",
                                  optional: false,
                                      type: String,
                              verify_block: proc do |value|
                                UI.user_error!("No Codemagic application ID given, pass it using `app_id` parameter to the Codemagic plugin.") unless value && !value.empty?
                              end),

          FastlaneCore::ConfigItem.new(key: :workflow_id,
                                  env_name: "CODEMAGIC_WORKFLOW_ID",
                               description: "Codemagic workflow identifier as specified in YAML file",
                                  optional: false,
                                      type: String,
                              verify_block: proc do |value|
                                UI.user_error!("No Codemagic workflow ID given, pass it using `workflow_id` parameter to the Codemagic plugin.") unless value && !value.empty?
                              end),

          FastlaneCore::ConfigItem.new(key: :auth_token,
                                  env_name: "CODEMAGIC_AUTH_TOKEN",
                               description: "Codemagic Auth Token",
                                  optional: false,
                                      type: String,
                              verify_block: proc do |value|
                                UI.user_error!("No Codemagic auth token given, pass it using `auth_token` parameter to the Codemagic plugin.") unless value && !value.empty?
                              end),

          FastlaneCore::ConfigItem.new(key: :branch,
                                  env_name: "CODEMAGIC_BRANCH",
                               description: "Codemagic branch name",
                                  optional: false,
                                      type: String,
                              verify_block: proc do |value|
                                UI.user_error!("No Codemagic branch given, pass it using `branch` parameter to the Codemagic plugin.") unless value && !value.empty?
                              end),

          FastlaneCore::ConfigItem.new(key: :download,
                                       description: "Download Codemagic artefacts",
                                       optional: true,
                                       type: Object),

          FastlaneCore::ConfigItem.new(key: :environment,
                                       description: "Codemagic Specify environment variables and software versions to override values defined in workflow settings",
                                       optional: true,
                                       type: Object)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
