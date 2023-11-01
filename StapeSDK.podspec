Pod::Spec.new do |s|
  s.name             = 'StapeSDK'
  s.version          = '1.0.0'
  s.summary          = 'StapeSDK to use with Stape.io service'
  s.description      = 'Awesome Stape.io SDK, use it for fun and profit!'
  s.homepage         = 'https://stape.io'
  s.license          = { :type => 'Apache', :file => 'LICENSE' }
  s.author           = { 'Stape' => 'info@stape.com' }
  s.source           = { :git => 'https://github.com/stape-io/stape-sgtm-ios.git', :tag => s.version.to_s }
  s.swift_version    = '4.0'

  s.ios.deployment_target = '14.0'

  s.source_files = 'StapeSDK/StapeSDK/**/*'
end
