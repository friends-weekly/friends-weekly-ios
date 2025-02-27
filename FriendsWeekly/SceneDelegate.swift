//
//  SceneDelegate.swift
//  FriendsWeekly
//
//  Created by Stuart Yamartino on 2/26/25.
//

import HotwireNative
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private let navigator = Navigator()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        Style.configure()
        window?.rootViewController = navigator.rootViewController
        window?.tintColor = .indigo600
        navigator.route(Env.baseURL)
    }
}

