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

	enum ID: String, Decodable {
		case fivePin = "ca.josephroque.bowlingcompanion"
		case fivePinSecure = "ca.josephroque.bowlingcompanion.https"
	}

	let id: ID
	let name: String
	let iconName: String
	let serverUrl: String
	let serverApiKey: String
	let mixpanelApiKey: String
	let bugsnagApiKey: String

	var expectedRequests: Int {
		return services.reduce(0, { count, service in
			service.numberOfRequests
		})
	}

	var icon: UIImage {
		return UIImage(named: iconName)!
	}

	private var _transferService: TransferService!
	var transferService: TransferService {
		return _transferService
	}

	private var _mixpanelService: MixpanelService!
	var mixpanelService: MixpanelService {
		return _mixpanelService
	}

	var services: [Service] {
		return [
			transferService,
			mixpanelService
		]
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(ID.self, forKey: .id)
		self.name = try container.decode(String.self, forKey: .name)
		self.iconName = try container.decode(String.self, forKey: .iconName)
		self.serverUrl = try container.decode(String.self, forKey: .serverUrl)
		self.serverApiKey = try container.decode(String.self, forKey: .serverApiKey)
		self.mixpanelApiKey = try container.decode(String.self, forKey: .mixpanelApiKey)
		self.bugsnagApiKey = try container.decode(String.self, forKey: .bugsnagApiKey)

		self._transferService = TransferService(url: serverUrl, apiKey: serverApiKey)
		self._mixpanelService = MixpanelService(apiKey: mixpanelApiKey)
	}

	public static func ==(lhs: App, rhs: App) -> Bool {
		return lhs.id == rhs.id
	}

	public var hashValue: Int {
		return id.hashValue
	}
}
