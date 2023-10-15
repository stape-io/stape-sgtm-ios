Pod::Spec.new do |s|
  s.name             = 'StapeSDK'
  s.version          = '0.1.0'
  s.summary          = 'StapeSDK to use with Stape.io service'
  s.description      = 'Awesome Stape.io SDK, use it for fun and profit!'
  s.homepage         = 'https://stape.io'
  s.license          = { :type => 'Apache', :file => 'LICENSE' }
  s.author           = { 'Stape' => 'info@stape.com' }
  s.source           = { :git => 'https://github.com/stape-io/stape-sgtm-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'

  s.source_files = 'StapeSDK/StapeSDK/**/*'
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
