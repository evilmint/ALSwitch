Pod::Spec.new do |s|
    s.platform = :ios
    s.ios.deployment_target = '10.0'
    s.name = "ALSwitch"
    s.summary = "ALSwitch is a CoreGraphics implementation of a UISwitch."
    s.requires_arc = true

    s.version = "0.1.3"
    s.license = { :type => "MIT", :file => "LICENSE" }
    s.author = { "Aleksander Lorenc" => "lorencaleksander@gmail.com" }

    s.homepage = "https://github.com/evilmint/ALSwitch"
    s.source = { :git => "https://github.com/evilmint/ALSwitch.git", :tag => "#{s.version}" }

    s.framework = "UIKit"

    s.source_files = "ALSwitch/**/*.{swift}"

    s.swift_version = "4.2"
end
