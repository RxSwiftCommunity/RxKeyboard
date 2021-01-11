Pod::Spec.new do |s|
  s.name             = 'RxKeyboard'
  s.version          = '2.0.0'
  s.summary          = 'Reactive Keyboard in iOS'
  s.homepage         = 'https://github.com/RxSwiftCommunity/RxKeyboard'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Suyeol Jeon' => 'devxoul@gmail.com' }
  s.source           = { :git => 'https://github.com/RxSwiftCommunity/RxKeyboard.git',
                         :tag => s.version.to_s }
  s.source_files     = 'Sources/**/*.swift'
  s.frameworks       = 'UIKit'
  s.requires_arc     = true
  s.swift_version    = "5.1"

  s.dependency 'RxSwift', '~> 6.0'
  s.dependency 'RxCocoa', '~> 6.0'

  s.ios.deployment_target = '9.0'
end
