//
//  Constants.swift
//  FriendsWeekly
//
//  Created by Stuart Yamartino on 2/26/25.
//

import Foundation

let productionURL = "https://friendsweekly.com"
let localURL = "http://localhost:3000"
let stuURL = "https://stu.ngrok.io"

enum Env {
    static let baseURL = URL(string: productionURL)! // Change this variable to update local vs prod
	static let remotePathConfigURL = URL(string: "\(baseURL.absoluteString)/configurations/ios_v1.json")!
}
