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
    private let navigator = Navigator(configuration: .init(
        name: "main",
        startLocation: Env.baseURL
    ))

	/// Called on app launch
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        Style.configure()

        // Set the main app as the root view controller and start loading
        window?.rootViewController = navigator.rootViewController

        // Determine the URL to route to
        if let userActivity = connectionOptions.userActivities.first, let url = getUniversalLink(userActivity) {
            routeTo(url)
        } else {
            routeTo(Env.baseURL)
        }

        // Add the launch view controller's view on top while content loads
        let launchViewController = LaunchViewController()
        launchViewController.onComplete = { [weak self] in
            self?.hideLaunchScreen(launchViewController)
        }

        // Add the launch view as a subview covering everything
        if let rootView = window?.rootViewController?.view {
            launchViewController.view.frame = rootView.bounds
            rootView.addSubview(launchViewController.view)
        }
    }

    /// Hide the launch screen after the delay
    private func hideLaunchScreen(_ launchViewController: LaunchViewController) {
        // Fade out the launch view
        UIView.animate(withDuration: 0.3, animations: {
            launchViewController.view.alpha = 0
        }) { _ in
            launchViewController.view.removeFromSuperview()
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
