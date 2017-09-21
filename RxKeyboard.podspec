Pod::Spec.new do |s|
  s.name             = 'RxKeyboard'
  s.version          = '0.7.0'
  s.summary          = 'Reactive Keyboard in iOS'
  s.homepage         = 'https://github.com/RxSwiftCommunity/RxKeyboard'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Suyeol Jeon' => 'devxoul@gmail.com' }
  s.source           = { :git => 'https://github.com/RxSwiftCommunity/RxKeyboard.git',
                         :tag => s.version.to_s }
  s.source_files     = 'Sources/*.swift'
  s.frameworks       = 'UIKit', 'Foundation'
  s.requires_arc     = true

  s.dependency 'RxSwift', '~> 4.0.0-beta.0'
  s.dependency 'RxCocoa', '~> 4.0.0-beta.0'

  s.ios.deployment_target = '8.0'

  s.pod_target_xcconfig = {
    'SWIFT_VERSION' => '4.0'
  }
end
