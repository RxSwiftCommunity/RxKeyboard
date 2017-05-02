//
//  RxKeyboardInteractive.swift
//  RxKeyboard
//
//  Created by Ian Ynda-Hummel on 5/2/17.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

internal extension RxKeyboard {
  internal func attachPanRecognizer() {
    NotificationCenter.default.rx.notification(.UIApplicationDidFinishLaunching)
      .map { _ in Void() }
      .startWith(Void()) // when RxKeyboard is initialized before UIApplication.window is created
      .subscribe(onNext: { _ in
        UIApplication.shared.windows.first?.addGestureRecognizer(self.panRecognizer)
      })
      .addDisposableTo(self.disposeBag)
  }
}
