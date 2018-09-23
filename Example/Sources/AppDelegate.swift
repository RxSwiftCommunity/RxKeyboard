//
//  AppDelegate.swift
//  RxKeyboardExample
//
//  Created by Suyeol Jeon on 09/10/2016.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import UIKit

import CGFloatLiteral
import ManualLayout
import SnapKit
import SwiftyColor
import Then
import UITextView_Placeholder

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  #if swift(>=4.2)
    typealias ApplicationLaunchOptionsKey = UIApplication.LaunchOptionsKey
  #else
    typealias ApplicationLaunchOptionsKey = UIApplicationLaunchOptionsKey
  #endif

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [ApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = .white
    window.makeKeyAndVisible()

    let messageListViewController = MessageListViewController()
    let navigationController = UINavigationController(rootViewController: messageListViewController)
    window.rootViewController = navigationController

    self.window = window
    return true
  }

}
