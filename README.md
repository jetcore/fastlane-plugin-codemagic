# codemagic plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-codemagic)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-codemagic`, add it to your project by running:

```bash
fastlane add_plugin codemagic
```

## About codemagic

Fastlane plugin to trigger a Codemagic build with some options

**Note to author:** Add a more detailed description about this plugin here. If your plugin contains multiple actions, make sure to mention them here.

## Options

| Option | Description | Type | Requirement | Environment Variable |
| --- | --- | :---: | :---: | --- |
| `auth_token` | Codemagic API access token is available via UI in User settings > Integrations > Codemagic API > Show | String | **Required** | `CODEMAGIC_AUTH_TOKEN` |
| `app_id` | Codemagic application identifier. | String | **Required** | `CODEMAGIC_APP_ID` |
| `workflow_id` | Codemagic workflow identifier as specified in YAML file. | String | **Required** | `CODEMAGIC_WORKFLOW_ID` |
| `branch` | Git branch name | String | **Required** | `CODEMAGIC_BRANCH` |
| `download` | Artefacts downloading options | Object | Optional |  **none** |
| `environment` | Codemagic specify environment variables and software versions to override values defined in workflow settings. | Object | Optional | **none** |

## Return values

If an error is return by the codemagic.io API, the plugin will **throw an exception**. 

## Examples

```
codemagic(
    workflow_id: "YOUR_WORKFLOW_ID",
    app_id: "YOUR_APP_ID",
    branch: "release/4.1.2",
    auth_token: "82Kf0RHv8MWS7VctoFHxGtW-wIWEkPUI0-E8DkJ4HaY",
    download: {
        artefacts: ["ipa"],
        build_path: "./build/"
    },
    environment: {
        variables: {
            "ENV": "production",
            "YET_ANOTHER_ENVIRONMENT_VARIABLE" => "123456" 
        },
        softwareVersions: {
            flutter: stable
            xcode: latest
            cocoapods: default
        }
    }
)
```
**Note to author:** Please set up a sample project to make it easy for users to explore what your plugin does. Provide everything that is necessary to try out the plugin in this project (including a sample Xcode/Android project if necessary)

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
