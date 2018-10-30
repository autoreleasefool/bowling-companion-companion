//
//  App.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-10-28.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import UIKit

enum ServerStatus: String, Codable {
	case online = "Online"
	case offline = "Offline"
	case loading = "Loading"
}

struct App: Equatable, Hashable, Decodable {
	private enum CodingKeys: String, CodingKey {
		case id
		case name = "Name"
		case iconName = "Icon"
		case serverUrl = "ServerURL"
		case serverApiKey = "ServerApiKey"
		case mixpanelApiKey = "MixpanelApiKey"
		case bugsnagApiKey = "BugsnagApiKey"
	}

	let id: String
	let name: String
	let iconName: String
	let serverUrl: String
	let serverApiKey: String
	let mixpanelApiKey: String
	let bugsnagApiKey: String

	var icon: UIImage {
		return UIImage(named: iconName)!
	}

	var dailyActiveUsers: Int = 0
	var monthlyActiveUsers: Int = 0

	var crashes: Int = 0

	var serverStatus: ServerStatus = .loading

	init(id: String, name: String, iconName: String, serverUrl: String, serverApiKey: String, mixpanelApiKey: String, bugsnagApiKey: String) {
		self.id = id
		self.name = name
		self.iconName = iconName
		self.serverUrl = serverUrl
		self.serverApiKey = serverApiKey
		self.mixpanelApiKey = mixpanelApiKey
		self.bugsnagApiKey = bugsnagApiKey
	}

	public static func ==(lhs: App, rhs: App) -> Bool {
		return lhs.id == rhs.id
	}

	public var hashValue: Int {
		return id.hashValue
	}
}
