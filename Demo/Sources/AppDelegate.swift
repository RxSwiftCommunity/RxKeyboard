//
//  AppDelegate.swift
//  Demo
//
//  Created by Suyeol Jeon on 09/10/2016.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import UIKit

import Then
import UITextView_Placeholder

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = .white
    window.rootViewController = UINavigationController(rootViewController: ViewController())
    window.makeKeyAndVisible()

    self.window = window
    return true
  }

}
