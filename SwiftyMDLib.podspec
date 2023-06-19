Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '13.0'
s.name = "SwiftyMDLib"
s.summary = "SwiftyMDLib MagicDevs Common Lib."
s.requires_arc = true

# 2
s.version = "1.2.7"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "Magic Developers" => "gevorgian.sargis@gmail.com" }
s.homepage = "https://github.com/SargisGevorgyan/SwiftyMDLib"
s.source = { :git => "https://github.com/SargisGevorgyan/SwiftyMDLib.git",
:tag => "#{s.version}" }

# 7
s.framework = "UIKit"
s.dependency 'Alamofire'
s.dependency 'SDWebImage', '5.15.2'
s.dependency 'IQKeyboardManagerSwift'
s.dependency 'lottie-ios'

# Firebase/Crashlytics
#s.dependency 'Firebase/Core'
#s.dependency 'Firebase/Messaging'
#s.dependency 'Firebase/Analytics'
#s.dependency 'Fabric'
#s.dependency 'Crashlytics'

# 8
s.source_files = 'SwiftyMDLib/Classes/**/*.{swift,m,h}'
#s.resources = 'SwiftyMDLib/Resources/*.*'
# s.resource_bundles = {
#   'SwiftyMDLib' => ['SwiftyMDLib/Resources/*.*']
# }

# 9
#s.resources = "SwiftyMDLib/Resources/**/*.{otf,xcdatamodeld,xcassets}"

s.resources = [
'SwiftyMDLib/Resources/**/*.xcdatamodeld',
'SwiftyMDLib/Resources/**/*.otf',
]

# 10
s.swift_version = "5.0"

end

# cd /Users/sargisgevorgyan/Documents/Projects/SwiftyMDLib
# pod trunk push
# pod trunk push --allow-warnings
