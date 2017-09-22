//
//  MessageCell.swift
//  RxKeyboard
//
//  Created by Suyeol Jeon on 18/01/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import SwiftyImage

final class MessageCell: UICollectionViewCell {

  // MARK: Types

  fileprivate enum BalloonAlignment {
    case left
    case right
  }


  // MARK: Constants

  struct Metric {
    static let maximumBalloonWidth = 240.f
    static let balloonViewInset = 10.f
  }

  struct Font {
    static let label = UIFont.systemFont(ofSize: 14)
  }


  // MARK: Properties

  fileprivate var balloonAlignment: BalloonAlignment = .left


  // MARK: UI

  fileprivate let otherBalloonViewImage = UIImage.resizable()
    .corner(radius: 5)
    .color(0xD9D9D9.color)
    .image
  fileprivate let myBalloonViewImage = UIImage.resizable()
    .corner(radius: 5)
    .color(0x1680FA.color)
    .image

  let balloonView = UIImageView()
  let label = UILabel().then {
    $0.font = Font.label
    $0.numberOfLines = 0
  }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.contentView.addSubview(self.balloonView)
    self.contentView.addSubview(self.label)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  func configure(message: Message) {
    self.label.text = message.text

    switch message.user {
    case .other:
      self.balloonAlignment = .left
      self.balloonView.image = self.otherBalloonViewImage
      self.label.textColor = .black

    case .me:
      self.balloonAlignment = .right
      self.balloonView.image = self.myBalloonViewImage
      self.label.textColor = .white
    }

    self.setNeedsLayout()
  }


  // MARK: Size

  class func size(thatFitsWidth width: CGFloat, forMessage message: Message) -> CGSize {
    let labelWidth = Metric.maximumBalloonWidth - Metric.balloonViewInset * 2
    let constraintSize = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
    let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
    let attributes: [NSAttributedStringKey: Any] = [.font: Font.label]
    let rect = message.text.boundingRect(with: constraintSize, options: options, attributes: attributes, context: nil)
    let labelHeight = ceil(rect.height)
    return CGSize(width: width, height: labelHeight + Metric.balloonViewInset * 2)
  }


  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()

    self.label.width = Metric.maximumBalloonWidth - Metric.balloonViewInset * 2
    self.label.sizeToFit()

    self.balloonView.width = self.label.width + Metric.balloonViewInset * 2
    self.balloonView.height = self.label.height + Metric.balloonViewInset * 2

    switch self.balloonAlignment {
    case .left:
      self.balloonView.left = 10
    case .right:
      self.balloonView.right = self.contentView.width - 10
    }

    self.label.top = self.balloonView.top + Metric.balloonViewInset
    self.label.left = self.balloonView.left + Metric.balloonViewInset
  }

}
