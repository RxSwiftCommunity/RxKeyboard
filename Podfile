platform :ios, '8.0'

target 'RxKeyboard' do
  use_frameworks!

  pod 'RxSwift', '3.0.0-beta.2'
  pod 'RxCocoa', '3.0.0-beta.2'

  target 'RxKeyboardDemo' do
    pod 'Then', '~> 2.0'
    pod 'UITextView+Placeholder', '~> 1.2'
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
