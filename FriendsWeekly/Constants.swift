//
//  Constants.swift
//  FriendsWeekly
//
//  Created by Stuart Yamartino on 2/26/25.
//

import Foundation

enum Env {
    static let baseURL = URL(string: productionURL)! // Change this variable to update local vs prod
	static let remotePathConfigURL = baseURL.appending(path: "configurations/v1.json")
}

private extension Env {
	static let productionURL = "https://friendsweekly.com"
	static let localURL = "http://localhost:3000"
	static let stuURL = "https://stu.ngrok.io"
}
