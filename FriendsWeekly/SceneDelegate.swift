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
    private let tabBarController = HotwireTabBarController(lazyLoadTabs: true)

	/// Called on app launch
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Load tabs, select Post tab, set to root view controller
        tabBarController.load(Tab.all)
        tabBarController.selectedIndex = 1
        window?.rootViewController = tabBarController

        // The signed-out navigator loads in the background to report auth state.
        // A universal link also opens in the tab bar, in case the user is signed in.
        if let userActivity = connectionOptions.userActivities.first, let url = getUniversalLink(userActivity) {
            navigator.route(url)
            routeTo(url)
        } else {
            navigator.route(Env.baseURL)
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

        // Open tapped push notifications (including the one that launched the app)
        PushNotifications.shared.openURL = { [weak self] url in
            self?.openNotification(url)
        }
    }

    func signedIn() {
        if window?.rootViewController == navigator.rootViewController {
            // Keep the page the user signed in from (e.g. an invite or /welcome)
            let signedOutURL = navigator.currentVisitableURL

            // Switch to tab bar controller with all tabs
            tabBarController.load(Tab.all)
            tabBarController.selectedIndex = 1
            window?.rootViewController = tabBarController

            if let signedOutURL, !isTabOrGetStarted(signedOutURL) {
                tabBarController.activeNavigator.route(signedOutURL)
            }
        }
    }

    func signedOut() {
        // Switch to just the hotwire view (navigator) with no tabs
        window?.rootViewController = navigator.rootViewController
    }

	/// Called when the app is running
	func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
		if let url = getUniversalLink(userActivity) {
			routeTo(url)
		}
	}

    /// Hide the launch screen after the delay
    private func hideLaunchScreen(_ launchViewController: LaunchViewController) {
        // Fade out the launch view
        UIView.animate(withDuration: 0.2, animations: {
            launchViewController.view.alpha = 0
        }) { _ in
            launchViewController.view.removeFromSuperview()
        }
    }

	/// Extract the universal link from the given user activity
	private func getUniversalLink(_ userActivity: NSUserActivity) -> URL? {
		guard userActivity.activityType == NSUserActivityTypeBrowsingWeb, let incomingURL = userActivity.webpageURL else {
			return nil
		}

		return incomingURL
	}

	/// Route to the given URL in whichever navigator is on screen
	private func routeTo(_ url: URL) {
		if window?.rootViewController == tabBarController {
			tabBarController.activeNavigator.route(url)
		} else {
			navigator.route(url)
		}
	}

	/// Open a tapped notification in whichever navigator is on screen
	private func openNotification(_ url: URL) {
		routeTo(url)
	}

	/// Tab roots and the signed-out landing page aren't worth carrying over after sign in
	private func isTabOrGetStarted(_ url: URL) -> Bool {
		let path = url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
		let tabPaths = Tab.all.map { $0.url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/")) }
		return path == "get_started_native" || tabPaths.contains(path)
	}
}
