platform :ios, '8.0'

target 'RxKeyboard' do
  use_frameworks!

  pod 'RxSwift', '>= 3.0'
  pod 'RxCocoa', '>= 3.0'

  target 'RxKeyboardDemo' do
    pod 'Then'
    pod 'UITextView+Placeholder'
    pod 'ReusableKit'
    pod 'SnapKit'
    pod 'ManualLayout'
    pod 'SwiftyColor'
    pod 'SwiftyImage'
    pod 'CGFloatLiteral'
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
