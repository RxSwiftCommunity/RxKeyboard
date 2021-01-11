//
//  RxKeyboard.swift
//  RxKeyboard
//
//  Created by Suyeol Jeon on 09/10/2016.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

#if os(iOS)
import UIKit

import RxCocoa
import RxSwift

public protocol RxKeyboardType {
  var frame: Driver<CGRect> { get }
  var visibleHeight: Driver<CGFloat> { get }
  var willShowVisibleHeight: Driver<CGFloat> { get }
  var isHidden: Driver<Bool> { get }
}

/// RxKeyboard provides a reactive way of observing keyboard frame changes.
public class RxKeyboard: NSObject, RxKeyboardType {

  // MARK: Public

  /// Get a singleton instance.
  public static let instance = RxKeyboard()

  /// An observable keyboard frame.
  public let frame: Driver<CGRect>

  /// An observable visible height of keyboard. Emits keyboard height if the keyboard is visible
  /// or `0` if the keyboard is not visible.
  public let visibleHeight: Driver<CGFloat>

  /// Same with `visibleHeight` but only emits values when keyboard is about to show. This is
  /// useful when adjusting scroll view content offset.
  public let willShowVisibleHeight: Driver<CGFloat>
  
  /// An observable visibility of keyboard. Emits keyboard visibility
  /// when changed keyboard show and hide.
  public let isHidden: Driver<Bool>

  // MARK: Private

  private let disposeBag = DisposeBag()
  private let panRecognizer = UIPanGestureRecognizer()

  // MARK: Initializing

  override init() {
    
    let keyboardWillChangeFrame = UIResponder.keyboardWillChangeFrameNotification
    let keyboardWillHide = UIResponder.keyboardWillHideNotification
    let keyboardFrameEndKey = UIResponder.keyboardFrameEndUserInfoKey

    let defaultFrame = CGRect(
      x: 0,
      y: UIScreen.main.bounds.height,
      width: UIScreen.main.bounds.width,
      height: 0
    )
    let frameVariable = BehaviorRelay<CGRect>(value: defaultFrame)
    self.frame = frameVariable.asDriver().distinctUntilChanged()
    self.visibleHeight = self.frame.map { UIScreen.main.bounds.height - $0.origin.y }
    self.willShowVisibleHeight = self.visibleHeight
      .scan((visibleHeight: 0, isShowing: false)) { lastState, newVisibleHeight in
        return (visibleHeight: newVisibleHeight, isShowing: lastState.visibleHeight == 0 && newVisibleHeight > 0)
      }
      .filter { state in state.isShowing }
      .map { state in state.visibleHeight }
    self.isHidden = self.visibleHeight.map({ $0 == 0.0 }).distinctUntilChanged()
    super.init()

    // keyboard will change frame
    let willChangeFrame = NotificationCenter.default.rx.notification(keyboardWillChangeFrame)
      .map { notification -> CGRect in
        let rectValue = notification.userInfo?[keyboardFrameEndKey] as? NSValue
        return rectValue?.cgRectValue ?? defaultFrame
      }
      .map { frame -> CGRect in
        if frame.origin.y < 0 { // if went to wrong frame
          var newFrame = frame
          newFrame.origin.y = UIScreen.main.bounds.height - newFrame.height
          return newFrame
        }
        return frame
      }

    // keyboard will hide
    let willHide = NotificationCenter.default.rx.notification(keyboardWillHide)
      .map { notification -> CGRect in
        let rectValue = notification.userInfo?[keyboardFrameEndKey] as? NSValue
        return rectValue?.cgRectValue ?? defaultFrame
      }
      .map { frame -> CGRect in
        if frame.origin.y < 0 { // if went to wrong frame
          var newFrame = frame
          newFrame.origin.y = UIScreen.main.bounds.height
          return newFrame
        }
        return frame
      }

    // pan gesture
    let didPan = self.panRecognizer.rx.event
      .withLatestFrom(frameVariable.asObservable()) { ($0, $1) }
      .flatMap { (gestureRecognizer, frame) -> Observable<CGRect> in
        guard case .changed = gestureRecognizer.state,
          let window = UIApplication.shared.windows.first,
          frame.origin.y < UIScreen.main.bounds.height
        else { return .empty() }
        let origin = gestureRecognizer.location(in: window)
        var newFrame = frame
        newFrame.origin.y = max(origin.y, UIScreen.main.bounds.height - frame.height)
        return .just(newFrame)
      }

    // merge into single sequence
    Observable.of(didPan, willChangeFrame, willHide).merge()
      .bind(to: frameVariable)
      .disposed(by: self.disposeBag)

    // gesture recognizer
    self.panRecognizer.delegate = self
    
    UIApplication.rx.didFinishLaunching // when RxKeyboard is initialized before UIApplication.window is created
      .subscribe(onNext: { _ in
        UIApplication.shared.windows.first?.addGestureRecognizer(self.panRecognizer)
      })
      .disposed(by: self.disposeBag)
  }

}


// MARK: - UIGestureRecognizerDelegate

extension RxKeyboard: UIGestureRecognizerDelegate {

  public func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldReceive touch: UITouch
  ) -> Bool {
    let point = touch.location(in: gestureRecognizer.view)
    var view = gestureRecognizer.view?.hitTest(point, with: nil)
    while let candidate = view {
      if let scrollView = candidate as? UIScrollView,
        case .interactive = scrollView.keyboardDismissMode {
        return true
      }
      view = candidate.superview
    }
    return false
  }

  public func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    gestureRecognizer === self.panRecognizer
  }

}
#endif

