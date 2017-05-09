//
//  MessageInputBar.swift
//  RxKeyboard
//
//  Created by Suyeol Jeon on 18/01/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class MessageInputBar: UIView {

  // MARK: Properties

  private let disposeBag = DisposeBag()


  // MARK: UI

  let toolbar = UIToolbar()
  let textView = UITextView().then {
    $0.placeholder = "Say Hi!"
    $0.isEditable = true
    $0.showsVerticalScrollIndicator = false
    $0.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
    $0.layer.borderWidth = 1 / UIScreen.main.scale
    $0.layer.cornerRadius = 3
  }
  let sendButton = UIButton(type: .system).then {
    $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
    $0.setTitle("Send", for: .normal)
  }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(self.toolbar)
    self.addSubview(self.textView)
    self.addSubview(self.sendButton)

    self.toolbar.snp.makeConstraints { make in
      make.edges.equalTo(0)
    }

    self.textView.snp.makeConstraints { make in
      make.top.left.equalTo(7)
      make.right.equalTo(self.sendButton.snp.left).offset(-7)
      make.bottom.equalTo(-7)
    }

    self.sendButton.snp.makeConstraints { make in
      make.top.equalTo(7)
      make.bottom.equalTo(-7)
      make.right.equalTo(-7)
    }

    self.textView.rx.text
      .map { text in text?.isEmpty == false }
      .bind(to: self.sendButton.rx.isEnabled)
      .disposed(by: self.disposeBag)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Size

  override var intrinsicContentSize: CGSize {
    return CGSize(width: self.width, height: 44)
  }

}


// MARK: - Reactive

extension Reactive where Base: MessageInputBar {

  var sendButtonTap: ControlEvent<String> {
    let source: Observable<String> = self.base.sendButton.rx.tap
      .withLatestFrom(self.base.textView.rx.text.asObservable())
      .flatMap { text -> Observable<String> in
        if let text = text, !text.isEmpty {
          return .just(text)
        } else {
          return .empty()
        }
      }
      .do(onNext: { [weak base = self.base] _ in
        base?.textView.text = nil
      })
    return ControlEvent(events: source)
  }

}
