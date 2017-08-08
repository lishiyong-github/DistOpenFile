
Pod::Spec.new do |s|

s.name = "DistOpenFile"

s.version = "1.0.0.4"

s.summary = "A Library for iOS DistOpenFile."

s.homepage = "https://github.com/lishiyong-github/DistOpenFile"

s.license = "MIT"

s.author = { "lishiyong-github" => "1525846137@qq.com" }

s.source = { :git => "https://github.com/lishiyong-github/DistOpenFile.git", :tag => s.version }

s.source_files = "DistOpenFile/*.{h,m}"

s.framework = 'UIKit'

s.ios.deployment_target = '8.0'

s.platform = :ios,"7.0"

s.dependency "AFNetworking", '~> 3.1.0' 

s.dependency "PureLayout",'~>3.0.2'

end
