//
//  Style.swift
//  FriendsWeekly
//
//  Created by Stuart Yamartino on 2/26/25.
//

import UIKit

enum Style {
    static func configure() {
		let navBarAppearance = lightModeNavBar()
		UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }

	private static func lightModeNavBar() -> UINavigationBarAppearance {
		let navBarAppearance = UINavigationBarAppearance()
		navBarAppearance.configureWithOpaqueBackground()
		/// Force light mode settings, until dark mode support is built on web
		navBarAppearance.backgroundColor = .white
		navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
		return navBarAppearance
	}
}
