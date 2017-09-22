//
//  MessageListViewController.swift
//  RxKeyboardExample
//
//  Created by Suyeol Jeon on 09/10/2016.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReusableKit
import RxKeyboard
import RxSwift

class MessageListViewController: UIViewController {

  // MARK: Constants

  struct Reusable {
    static let messageCell = ReusableCell<MessageCell>()
  }


  // MARK: Properties

  private var didSetupViewConstraints = false
  private let disposeBag = DisposeBag()

  fileprivate var messages: [Message] = [
    Message(user: .other, text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
    Message(user: .other, text: "Morbi et eros elementum, semper massa eu, pellentesque sapien."),
    Message(user: .me, text: "Aenean sollicitudin justo scelerisque tincidunt venenatis."),
    Message(user: .me, text: "Ut mollis magna nec interdum pellentesque."),
    Message(user: .me, text: "Aliquam semper nibh nec quam dapibus, a congue odio consequat."),
    Message(user: .other, text: "Nullam iaculis nisi in justo feugiat, at pharetra nulla dignissim."),
    Message(user: .me, text: "Fusce at nulla luctus, posuere mauris ut, viverra nunc."),
    Message(user: .other, text: "Nam feugiat urna non tortor ornare viverra."),
    Message(user: .other, text: "Donec vitae metus maximus, efficitur urna ac, blandit erat."),
    Message(user: .other, text: "Pellentesque luctus eros ac nisi ullamcorper pharetra nec vel felis."),
    Message(user: .me, text: "Duis vulputate magna quis urna porttitor, tempor malesuada metus volutpat."),
    Message(user: .me, text: "Duis aliquam urna quis metus tristique eleifend."),
    Message(user: .other, text: "Cras quis orci quis nisi vulputate mollis ut vitae magna."),
    Message(user: .other, text: "Fusce eu urna eu ipsum laoreet lobortis."),
    Message(user: .other, text: "Proin vitae tellus nec odio consequat varius ac non orci."),
    Message(user: .me, text: "Maecenas gravida arcu ut consectetur tincidunt."),
    Message(user: .me, text: "Quisque accumsan nisl ut ipsum rutrum, nec rutrum magna lobortis."),
    Message(user: .other, text: "Integer ac sem eu velit tincidunt hendrerit a in dui."),
    Message(user: .other, text: "Duis posuere arcu convallis tincidunt faucibus."),
  ]


  // MARK: UI

  let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
    $0.alwaysBounceVertical = true
    $0.keyboardDismissMode = .interactive
    $0.backgroundColor = .clear
    $0.register(Reusable.messageCell)
    ($0.collectionViewLayout as? UICollectionViewFlowLayout)?.do {
      $0.minimumLineSpacing = 6
      $0.sectionInset.top = 10
      $0.sectionInset.bottom = 10
    }
  }
  let messageInputBar = MessageInputBar()


  // MARK: Initializing

  init() {
    super.init(nibName: nil, bundle: nil)
    self.title = "RxKeyboard Example"
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(self.collectionView)
    self.view.addSubview(self.messageInputBar)

    self.collectionView.dataSource = self
    self.collectionView.delegate = self

    DispatchQueue.main.async {
      let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
      self.collectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }

    RxKeyboard.instance.visibleHeight
      .drive(onNext: { [weak self] keyboardVisibleHeight in
        guard let `self` = self, self.didSetupViewConstraints else { return }
        var actualKeyboardHeight = keyboardVisibleHeight
        if #available(iOS 11.0, *), keyboardVisibleHeight > 0 {
          actualKeyboardHeight = actualKeyboardHeight - self.view.safeAreaInsets.bottom
        }
        
        self.messageInputBar.snp.updateConstraints { make in
          make.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(-actualKeyboardHeight)
        }
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0) {
          self.collectionView.contentInset.bottom = keyboardVisibleHeight + self.messageInputBar.height
          self.collectionView.scrollIndicatorInsets.bottom = self.collectionView.contentInset.bottom
          self.view.layoutIfNeeded()
        }
      })
      .disposed(by: self.disposeBag)

    RxKeyboard.instance.willShowVisibleHeight
      .drive(onNext: { keyboardVisibleHeight in
        self.collectionView.contentOffset.y += keyboardVisibleHeight
      })
      .disposed(by: self.disposeBag)

    self.messageInputBar.rx.sendButtonTap
      .subscribe(onNext: { [weak self] text in
        guard let `self` = self else { return }
        let message = Message(user: .me, text: text)
        self.messages.append(message)
        let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
        self.collectionView.insertItems(at: [indexPath])
        self.collectionView.scrollToItem(at: indexPath, at: [], animated: true)
      })
      .disposed(by: self.disposeBag)
  }


  // MARK: Auto Layout

  override func updateViewConstraints() {
    super.updateViewConstraints()
    guard !self.didSetupViewConstraints else { return }
    self.didSetupViewConstraints = true

    self.collectionView.snp.makeConstraints { make in
      make.edges.equalTo(0)
    }
    self.messageInputBar.snp.makeConstraints { make in
      make.left.right.equalTo(0)
      make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if self.collectionView.contentInset.bottom == 0 {
      self.collectionView.contentInset.bottom = self.messageInputBar.height
      self.collectionView.scrollIndicatorInsets.bottom = self.collectionView.contentInset.bottom
    }
  }

}


// MARK: - UICollectionViewDataSource

extension MessageListViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.messages.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeue(Reusable.messageCell, for: indexPath)
    cell.configure(message: self.messages[indexPath.item])
    return cell
  }

}


// MARK: - UICollectionViewDelegateFlowLayout

extension MessageListViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let message = self.messages[indexPath.item]
    return MessageCell.size(thatFitsWidth: collectionView.width, forMessage: message)
  }

}
