//
//  App.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-10-28.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import UIKit

struct App: Decodable {
	private enum CodingKeys: String, CodingKey {
		case id = "ID"
		case name = "Name"
		case iconName = "Icon"
		case serverUrl = "ServerURL"
		case serverApiKey = "ServerApiKey"
		case secureServerUrl = "SecureServerURL"
		case secureServerApiKey = "SecureServerApiKey"
		case mixpanelApiKey = "MixpanelApiKey"
		case bugsnagApiKey = "BugsnagApiKey"
		case bugsnagProjectId = "BugsnagProjectID"
	}

	let id: String
	let name: String
	let iconName: String
	let serverUrl: String
	let serverApiKey: String
	let secureServerUrl: String?
	let secureServerApiKey: String?
	let mixpanelApiKey: String
	let bugsnagApiKey: String
	let bugsnagProjectId: String

	var icon: UIImage {
		return UIImage(named: iconName)!
	}

	private var _transferService: TransferService
	var transferService: TransferService {
		return _transferService
	}

	private var _secureTransferService: TransferService?
	var secureTransferService: TransferService? {
		return _secureTransferService
	}

	private var _mixpanelService: MixpanelService
	var mixpanelService: MixpanelService {
		return _mixpanelService
	}

	private var _bugsnagService: BugsnagService
	var bugsnagService: BugsnagService {
		return _bugsnagService
	}

	var services: [Service] {
		var services: [Service] = []
		if let secureTransferService = secureTransferService {
			services.append(secureTransferService)
		}
		services.append(transferService)
		services.append(mixpanelService)
		services.append(bugsnagService)
		return services
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
		self.bugsnagProjectId = try container.decode(String.self, forKey: .bugsnagProjectId)

		self._transferService = TransferService(url: serverUrl, apiKey: serverApiKey)
		self._mixpanelService = MixpanelService(apiKey: mixpanelApiKey)
		self._bugsnagService = BugsnagService(projectId: bugsnagProjectId, apiKey: bugsnagApiKey)

		self.secureServerUrl = try container.decodeIfPresent(String.self, forKey: .secureServerUrl)
		self.secureServerApiKey = try container.decodeIfPresent(String.self, forKey: .secureServerApiKey)
		if let url = self.secureServerUrl, let apiKey = self.secureServerApiKey {
			self._secureTransferService = TransferService(url: url, apiKey: apiKey, isSecure: true)
		} else {
			self._secureTransferService = nil
		}
	}
}
