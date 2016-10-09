//
//  ViewController.swift
//  Demo
//
//  Created by Suyeol Jeon on 09/10/2016.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import UIKit

import RxKeyboard
import RxSwift

class ViewController: UIViewController {

  let textView = UITextView().then {
    $0.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    $0.placeholder = "Scroll down to dismiss keyboard."
    $0.isEditable = true
    $0.alwaysBounceVertical = true
    $0.keyboardDismissMode = .interactive
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  let toolbar = UIToolbar().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  var toolbarBottomConstraint: NSLayoutConstraint?
  let labelItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil).then {
    $0.isEnabled = false
  }
  let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)

  let disposeBag = DisposeBag()

  init() {
    super.init(nibName: nil, bundle: nil)
    self.title = "RxKeyboard Demo"

    self.toolbar.items = [
      UIBarButtonItem(image: self.makeUpArrowImage(), style: .plain, target: nil, action: nil)
        .then { $0.isEnabled = false },
      UIBarButtonItem(image: self.makeDownArrowImage(), style: .plain, target: nil, action: nil)
        .then { $0.isEnabled = false },
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      self.labelItem,
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      self.doneButtonItem,
    ]
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.textView.becomeFirstResponder()
    self.view.addSubview(self.textView)
    self.view.addSubview(self.toolbar)
    self.setupConstraints()

    RxKeyboard.instance.visibleHeight
      .drive(onNext: { [weak self] keyboardVisibleHeight in
        self?.toolbarBottomConstraint?.constant = -keyboardVisibleHeight
        self?.view.setNeedsLayout()
        UIView.animate(withDuration: 0) {
          self?.view.layoutIfNeeded()
        }
      })
      .addDisposableTo(self.disposeBag)

    RxKeyboard.instance.visibleHeight
      .drive(onNext: { [weak self] in
        self?.labelItem.title = "height: \($0)"
      })
      .addDisposableTo(self.disposeBag)

    self.doneButtonItem.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.textView.resignFirstResponder()
      })
      .addDisposableTo(self.disposeBag)
  }


  // MARK: Auto Layout

  private func setupConstraints() {
    // text view
    NSLayoutConstraint.activate([
      NSLayoutConstraint(
        item: self.textView,
        attribute: .width,
        relatedBy: .equal,
        toItem: self.view,
        attribute: .width,
        multiplier: 1,
        constant: 0
      ),
      NSLayoutConstraint(
        item: self.textView,
        attribute: .height,
        relatedBy: .equal,
        toItem: self.view,
        attribute: .height,
        multiplier: 1,
        constant: 0
      ),
    ])

    // toolbar
    self.toolbarBottomConstraint = NSLayoutConstraint(
      item: self.toolbar,
      attribute: .bottom,
      relatedBy: .equal,
      toItem: self.view,
      attribute: .bottom,
      multiplier: 1,
      constant: 0
    )
    guard let toolbarBottomConstraint = self.toolbarBottomConstraint else { return }
    NSLayoutConstraint.activate([
      NSLayoutConstraint(
        item: self.toolbar,
        attribute: .width,
        relatedBy: .equal,
        toItem: self.view,
        attribute: .width,
        multiplier: 1,
        constant: 0
      ),
      NSLayoutConstraint(
        item: self.toolbar,
        attribute: .height,
        relatedBy: .equal,
        toItem: nil,
        attribute: .notAnAttribute,
        multiplier: 1,
        constant: 44
      ),
      toolbarBottomConstraint,
    ])
  }


  // MARK: Image Factory

  private func makeUpArrowImage() -> UIImage? {
    let size = CGSize(width: 21, height: 12)
    let lineWidth: CGFloat = 1.5
    UIGraphicsBeginImageContextWithOptions(size, false, 0)

    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    context.move(to: CGPoint(x: lineWidth / 2, y: size.height - lineWidth / 2))
    context.addLine(to: CGPoint(x: size.width / 2, y: lineWidth / 2))
    context.addLine(to: CGPoint(x: size.width - lineWidth / 2, y: size.height - lineWidth / 2))
    context.setLineWidth(lineWidth)

    UIColor.black.setStroke()
    context.strokePath()

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }

  private func makeDownArrowImage() -> UIImage? {
    let size = CGSize(width: 21, height: 12)
    let lineWidth: CGFloat = 1.5
    UIGraphicsBeginImageContextWithOptions(size, false, 0)

    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    context.move(to: CGPoint(x: lineWidth / 2, y: lineWidth / 2))
    context.addLine(to: CGPoint(x: size.width / 2, y: size.height - lineWidth / 2))
    context.addLine(to: CGPoint(x: size.width - lineWidth / 2, y: lineWidth / 2))
    context.setLineWidth(lineWidth)

    UIColor.black.setStroke()
    context.strokePath()

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }

}
