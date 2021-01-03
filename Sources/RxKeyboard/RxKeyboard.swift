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

        let defaultFrame = CGRect(
            x: .zero,
            y: UIScreen.main.bounds.height,
            width: UIScreen.main.bounds.width,
            height: .zero
        )

        let frameVariable = BehaviorRelay<CGRect>(value: defaultFrame)

        frame = frameVariable.asDriver().distinctUntilChanged()
        visibleHeight = frame.map { UIScreen.main.bounds.height - $0.origin.y }

        willShowVisibleHeight = visibleHeight
            .scan((visibleHeight: .zero, isShowing: false)) { lastState, newVisibleHeight in
                (visibleHeight: newVisibleHeight, isShowing: lastState.visibleHeight <= .zero && newVisibleHeight > .zero)
            }
            .filter { $0.isShowing }
            .map { $0.visibleHeight }

        isHidden = visibleHeight
            .map { $0 <= .ulpOfOne }
            .distinctUntilChanged()

        super.init()

        // keyboard will change frame
        let willChangeFrame = NotificationCenter.default.rx.notification(.keyboardWillChangeFrame)
            .map { notification -> CGRect in
                let rectValue = notification.userInfo?[String.keyboardFrameEndKey] as? NSValue
                return rectValue?.cgRectValue ?? defaultFrame
            }
            .map { frame -> CGRect in
                if frame.origin.y < .zero { // if went to wrong frame
                    var newFrame = frame
                    newFrame.origin.y = UIScreen.main.bounds.height - newFrame.height
                    return newFrame
                }
                return frame
            }

        // keyboard will hide
        let willHide = NotificationCenter.default.rx.notification(.keyboardWillHide)
            .map { notification -> CGRect in
                let rectValue = notification.userInfo?[String.keyboardFrameEndKey] as? NSValue
                return rectValue?.cgRectValue ?? defaultFrame
            }
            .map { frame -> CGRect in
                if frame.origin.y < .zero { // if went to wrong frame
                    var newFrame = frame
                    newFrame.origin.y = UIScreen.main.bounds.height
                    return newFrame
                }
                return frame
            }

        // pan gesture
        let didPan = panRecognizer.rx.event
            .withLatestFrom(frameVariable.asObservable()) { ($0, $1) }
            .flatMap { (gestureRecognizer, frame) -> Observable<CGRect> in
                guard case .changed = gestureRecognizer.state,
                      let window = UIApplication.shared.windows.first,
                      frame.origin.y < UIScreen.main.bounds.height else {
                    return .empty()
                }

                let origin = gestureRecognizer.location(in: window)
                var newFrame = frame
                newFrame.origin.y = max(origin.y, UIScreen.main.bounds.height - frame.height)
                return .just(newFrame)
            }

        // merge into single sequence
        Observable.merge(didPan, willChangeFrame, willHide)
            .bind(to: frameVariable)
            .disposed(by: disposeBag)

        // gesture recognizer
        panRecognizer.delegate = self

        UIApplication.rx.didFinishLaunching // when RxKeyboard is initialized before UIApplication.window is created
            .withUnretained(panRecognizer)
            .subscribe { gestureRecognizer, _ in
                UIApplication.shared.windows.first?.addGestureRecognizer(gestureRecognizer)
            }
            .disposed(by: disposeBag)
    }
}


// MARK: - UIGestureRecognizerDelegate

extension RxKeyboard: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
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
        return gestureRecognizer === panRecognizer
    }
}

private extension Notification.Name {

    static let keyboardWillChangeFrame = UIResponder.keyboardWillChangeFrameNotification
    static let keyboardWillHide = UIResponder.keyboardWillHideNotification
}

private extension String {

    static let keyboardFrameEndKey = UIResponder.keyboardFrameEndUserInfoKey
}

#endif

