//
//  App.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-10-28.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import UIKit

struct App: Equatable, Hashable, Decodable {
	private enum CodingKeys: String, CodingKey {
		case id = "ID"
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

	private var _transferServer: TransferServer!
	var transferServer: TransferServer {
		return _transferServer
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(String.self, forKey: .id)
		self.name = try container.decode(String.self, forKey: .name)
		self.iconName = try container.decode(String.self, forKey: .iconName)
		self.serverUrl = try container.decode(String.self, forKey: .serverUrl)
		self.serverApiKey = try container.decode(String.self, forKey: .serverApiKey)
		self.mixpanelApiKey = try container.decode(String.self, forKey: .mixpanelApiKey)
		self.bugsnagApiKey = try container.decode(String.self, forKey: .bugsnagApiKey)

		self._transferServer = TransferServer(url: serverUrl, apiKey: serverApiKey)
	}

	public static func ==(lhs: App, rhs: App) -> Bool {
		return lhs.id == rhs.id
	}

	public var hashValue: Int {
		return id.hashValue
	}
}
