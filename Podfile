platform :ios, '8.0'

target 'RxKeyboard' do
  use_frameworks!

  pod 'RxSwift', '>= 3.0'
  pod 'RxCocoa', '>= 3.0'

  target 'RxKeyboardDemo' do
    inherit! :search_paths
    pod 'Then', '~> 2.0'
    pod 'UITextView+Placeholder', '~> 1.2'
    pod 'RxKeyboard', :path => './'
  end

end
