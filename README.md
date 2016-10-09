# RxKeyboard

![Swift](https://img.shields.io/badge/Swift-3.0-orange.svg)
[![CocoaPods](http://img.shields.io/cocoapods/v/RxKeyboard.svg)](https://cocoapods.org/pods/RxKeyboard)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

RxKeyboard provides a reactive way of keyboard handling. Forget about `UIKeyboardWillShow` and `UIKeyboardWillHide`. It also perfectly works with `UIScrollViewKeyboardDismissMode.interactive`.

![rxkeyboard mov](https://cloud.githubusercontent.com/assets/931655/19223553/82b3fa5a-8ead-11e6-8cb5-ec13ee09eb50.gif)

## At a Glance

Observing keyboard frame:

```swift
RxKeyboard.instance.frame
  .drive(onNext: { frame in
    print(frame)
  })
  .addDisposableTo(disposeBag)
```

Observing keyboard visible height:

```swift
RxKeyboard.instance.visibleHeight
  .drive(onNext: { keyboardVisibleHeight in
    toolbarBottomConstraint.constant = -1 * keyboardVisibleHeight
  })
  .addDisposableTo(disposeBag)
```
    
> **Note**: In real world, you should use `setNeedsLayout` and `layoutIfNeeded`. See the [demo project](https://github.com/devxoul/RxKeyboard/blob/master/Demo/Sources/ViewControllers/ViewController.swift#L62-L70) for example.
    
## Dependencies

- [RxSwift](https://github.com/ReactiveX/RxSwift) (= 3.0.0-beta.2)
- [RxCocoa](https://github.com/ReactiveX/RxSwift) (= 3.0.0-beta.2)

## Requirements

- Swift 3
- iOS 8+

## Installation

- **Using [CocoaPods](https://cocoapods.org)**:

    ```ruby
    pod 'RxKeyboard', '~> 0.1'
    ```

- **Using [Carthage](https://github.com/Carthage/Carthage)**:

    ```
    github "devxoul/RxKeyboard" ~> 0.1
    ```

## License

RxKeyboard is under MIT license.
