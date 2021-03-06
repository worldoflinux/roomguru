#
#  Podfile
#
#  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
#

# Pod sources
source 'https://github.com/CocoaPods/Specs.git'

# Initial configuration
platform :ios, '8.0'
inhibit_all_warnings!
use_frameworks!

xcodeproj 'Roomguru', 'Development' => :debug, 'Production' => :release, 'Staging' => :release, 'Test' => :debug

pod 'Google/SignIn' # Fails when version is specified

# "tag" given because there is no latest version in pods
pod 'Async',
    :git => "https://github.com/duemunk/Async.git",
    :tag => "1.4"

pod 'SwiftyJSON', '~> 2.3'

pod 'Cartography', '~> 0.6'

pod 'CryptoSwift', '~> 0.1'

pod 'AKPickerView-Swift', '~> 1.0'

pod 'SwiftyUserDefaults', '~> 2.0'

pod 'PKHUD', '~> 2.2'

pod 'FontAwesome.swift', '~> 0.4'

pod 'FontAwesomeIconFactory', '~> 2.1'

pod 'Timepiece', '~> 0.4'

pod 'HockeySDK', '~> 3.8'

target 'Tests' do link_with 'Unit Tests', 'Functional Tests'

    pod 'KIF', '~> 3.3',
        :configurations => ['Test']

    pod 'Quick', '~> 0.8',
        :configurations => ['Test']

    pod 'Nimble', '~> 3.0',
        :configurations => ['Test']
end

post_install do |installer|

    puts 'Setting appropriate code signing identities'
    installer.pods_project.targets.each { |target|
        {
            'iPhone Developer' => ['Debug', 'Development', 'Test'],
            'iPhone Distribution' => ['Release', 'Staging', 'Production'],
        }.each { |value, configs|
            target.set_build_setting('CODE_SIGN_IDENTITY[sdk=iphoneos*]', value, configs)
        }
    }

end

class Xcodeproj::Project::Object::PBXNativeTarget

    def set_build_setting setting, value, config = nil
        unless config.nil?
            if config.kind_of?(Xcodeproj::Project::Object::XCBuildConfiguration)
                config.build_settings[setting] = value
            elsif config.kind_of?(String)
                build_configurations
                .select { |config_obj| config_obj.name == config }
                .each { |config| set_build_setting(setting, value, config) }
            elsif config.kind_of?(Array)
                config.each { |config| set_build_setting(setting, value, config) }
            else
                raise 'Unsupported configuration type: ' + config.class.inspect
            end
        else
            set_build_setting(setting, value, build_configurations)
        end
    end

end
