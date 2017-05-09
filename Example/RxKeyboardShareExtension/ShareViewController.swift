//
//  ShareViewController.swift
//  RxKeyboardShareExtension
//
//  Created by Suyeol Jeon on 04/05/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit
import Social
import RxKeyboard
import RxSwift
import SnapKit

class ShareViewController: UIViewController {
  let disposeBag = DisposeBag()
  let textView = UITextView()
  let toolbar = UIToolbar()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.textView.font = UIFont.systemFont(ofSize: 50)
    self.textView.text = (0...100).map { "\($0)" }.joined(separator: "\n")
    self.textView.keyboardDismissMode = .interactive
    self.view.addSubview(self.textView)
    self.view.addSubview(self.toolbar)

    self.textView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    self.toolbar.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.bottom.equalToSuperview()
    }

    // Set `gestureValue` for using interactive keyboard tracking
    RxKeyboard.instance.gestureView = self.view
    RxKeyboard.instance.visibleHeight
      .drive(onNext: { [weak self] visibleHeight in
        guard let `self` = self else { return }
        self.toolbar.snp.updateConstraints { make in
          make.bottom.equalTo(-visibleHeight)
        }
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0) {
          self.textView.contentInset.bottom = visibleHeight + self.toolbar.frame.height
          self.textView.scrollIndicatorInsets.bottom = self.textView.contentInset.bottom
          self.view.layoutIfNeeded()
        }
      })
      .addDisposableTo(self.disposeBag)
  }
}
