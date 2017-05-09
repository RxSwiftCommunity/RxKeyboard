# RxKeyboard

![Swift](https://img.shields.io/badge/Swift-3.0-orange.svg)
[![CocoaPods](http://img.shields.io/cocoapods/v/RxKeyboard.svg)](https://cocoapods.org/pods/RxKeyboard)
[![Build Status](https://travis-ci.org/RxSwiftCommunity/RxKeyboard.svg?branch=master)](https://travis-ci.org/RxSwiftCommunity/RxKeyboard)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

RxKeyboard provides a reactive way of observing keyboard frame changes. Forget about keyboard notifications. It also perfectly works with `UIScrollViewKeyboardDismissMode.interactive`.

![rxkeyboard-message](https://cloud.githubusercontent.com/assets/931655/22062707/625eea7a-ddbe-11e6-9984-529abae1bd1a.gif)
![rxkeyboard-textview](https://cloud.githubusercontent.com/assets/931655/19223656/14bd915c-8eb0-11e6-93ea-7618fc9c5d81.gif)

## Getting Started

RxKeyboard provides two [`Driver`](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/Units.md#driver-unit)s.

```swift
/// An observable keyboard frame.
let frame: Driver<CGRect>

/// An observable visible height of keyboard. Emits keyboard height if the keyboard is visible
/// or `0` if the keyboard is not visible.
let visibleHeight: Driver<CGFloat>

/// Same with `visibleHeight` but only emits values when keyboard is about to show. This is
/// useful when adjusting scroll view content offset.
let willShowVisibleHeight: Driver<CGFloat>
```

Use `RxKeyboard.instance` to get singleton instance.

```swift
RxKeyboard.instance
```

Subscribe `RxKeyboard.instance.frame` to observe keyboard frame changes.

```swift
RxKeyboard.instance.frame
  .drive(onNext: { frame in
    print(frame)
  })
  .disposed(by: disposeBag)
```

## Tips and Tricks

- <a name="tip-content-inset" href="#tip-content-inset">🔗</a> **I want to adjust `UIScrollView`'s `contentInset` to fit keyboard height.**

    ```swift
    RxKeyboard.instance.visibleHeight
      .drive(onNext: { keyboardVisibleHeight in
        scrollView.contentInset.bottom = keyboardVisibleHeight
      })
      .disposed(by: disposeBag)
    ```

- <a name="tip-content-offset" href="#tip-content-offset">🔗</a> **I want to adjust `UIScrollView`'s `contentOffset` to fit keyboard height.**

    ```swift
    RxKeyboard.instance.willShowVisibleHeight
      .drive(onNext: { keyboardVisibleHeight in
        scrollView.contentInset.offset.y += keyboardVisibleHeight
      })
      .disposed(by: disposeBag)
    ```

- <a name="tip-toolbar" href="#tip-toolbar">🔗</a> **I want to make `UIToolbar` move along with the keyboard in an interactive dismiss mode. (Just like the wonderful GIF above!)**

    If you're not using Auto Layout:

    ```swift
    RxKeyboard.instance.visibleHeight
      .drive(onNext: { keyboardVisibleHeight in
        toolbar.frame.origin.y = self.view.height - toolbar.frame.height - keyboardVisibleHeight
      })
      .disposed(by: disposeBag)
    ```

    If you're using Auto Layout, you have to capture the toolbar's bottom constraint and set `constant` to keyboard visible height.

    ```swift
    RxKeyboard.instance.visibleHeight
      .drive(onNext: { keyboardVisibleHeight in
        toolbarBottomConstraint.constant = -1 * keyboardVisibleHeight
      })
      .disposed(by: disposeBag)
    ```

    > **Note**: In real world, you should use `setNeedsLayout()` and `layoutIfNeeded()` with animation block. See the [example project](https://github.com/RxSwiftCommunity/RxKeyboard/blob/master/Example/Sources/ViewControllers/MessageListViewController.swift#L92-L105) for example.

- <a name="tip-app-extension" href="#tip-app-extension">🔗</a> **I want to use RxKeyboard in App Extension.**

    App Extesion doesn't allow the `UIApplication.shared` API so the pan gesture recognizer cannot automatically track the interactive keybord dismissing. You have to do something manually in the App Extension target: setting `gestureView`.

    ```swift
    // ShareViewController.swift
    RxKeyboard.instance.gestureView = self.view // add this line on `viewDidLoad()`
    RxKeyboard.instance.visibleHeight.drive(...)
    ```

- Anything else? Please open an issue or make a Pull Request.
    
## Dependencies

- [RxSwift](https://github.com/ReactiveX/RxSwift) (>= 3.4)
- [RxCocoa](https://github.com/ReactiveX/RxSwift) (>= 3.4)

## Requirements

- Swift 3
- iOS 8+

## Installation

- **Using [CocoaPods](https://cocoapods.org)**:

    ```ruby
    pod 'RxKeyboard'
    ```

- **Using [Carthage](https://github.com/Carthage/Carthage)**:

    ```
    github "devxoul/RxKeyboard"
    ```

## License

RxKeyboard is under MIT license.
