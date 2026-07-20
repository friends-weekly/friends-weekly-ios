//
//  Constants.swift
//  FriendsWeekly
//
//  Created by Stuart Yamartino on 2/26/25.
//

import Foundation

enum Env {
    static let baseURL = URL(string: localURL)! // Change this variable to update local vs prod
	static let remotePathConfigURL = baseURL.appending(path: "configurations/ios_v2.json")
}

private extension Env {
	static let productionURL = "https://friendsweekly.com"
	static let localURL = "http://localhost:3000"
	static let tunnelURL = "https://mighty-intervention-attitude-olympic.trycloudflare.com"
}
