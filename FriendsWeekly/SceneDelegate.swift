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

	/// Called on app launch
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        Style.configure()
        window?.rootViewController = navigator.rootViewController

		if let userActivity = connectionOptions.userActivities.first, let url = getUniversalLink(userActivity) {
			routeTo(url)
		} else {
			routeTo(Env.baseURL)
		}
    }

	/// Called when the app is running
	func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
		if let url = getUniversalLink(userActivity) {
			routeTo(url)
		}
	}

	/// Extract the universal link from the given user activity
	private func getUniversalLink(_ userActivity: NSUserActivity) -> URL? {
		guard userActivity.activityType == NSUserActivityTypeBrowsingWeb, let incomingURL = userActivity.webpageURL else {
			return nil
		}

		return incomingURL
	}

	/// Route to the given URL
	private func routeTo(_ url: URL) {
		navigator.route(url)
	}
}
