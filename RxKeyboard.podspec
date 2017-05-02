Pod::Spec.new do |s|
  s.name             = 'RxKeyboard'
  s.version          = '0.4.1'
  s.summary          = 'Reactive Keyboard in iOS'
  s.homepage         = 'https://github.com/RxSwiftCommunity/RxKeyboard'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Suyeol Jeon' => 'devxoul@gmail.com' }
  s.source           = { :git => 'https://github.com/RxSwiftCommunity/RxKeyboard.git',
                         :tag => s.version.to_s }
  s.frameworks       = 'UIKit', 'Foundation'
  s.requires_arc     = true

  s.dependency 'RxSwift', '>= 3.0'
  s.dependency 'RxCocoa', '>= 3.0'

  s.subspec 'Core' do |core|
    core.source_files = 'Sources/RxKeyboard.swift'
  end

  s.subspec 'Interactive' do |interactive|
    interactive.source_files = 'Sources/RxKeyboardInteractive.swift'
  end

  s.ios.deployment_target = '8.0'

  s.pod_target_xcconfig = {
    'SWIFT_VERSION' => '3.0'
  }
end
