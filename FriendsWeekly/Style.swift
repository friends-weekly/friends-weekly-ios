//
//  Style.swift
//  FriendsWeekly
//
//  Created by Stuart Yamartino on 2/26/25.
//

import UIKit

enum Style {
    static func configure() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .white
        navBarAppearance.configureWithOpaqueBackground()
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
}
