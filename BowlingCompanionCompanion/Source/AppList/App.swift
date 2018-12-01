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
	}

	let id: String
	let name: String
	let icon: UIImage

	private var _transferService: TransferService
	var transferService: TransferService {
		return _transferService
	}

	private var _secureTransferService: TransferService? = nil
	var secureTransferService: TransferService? {
		return _secureTransferService
	}

	private var _mixpanelService: MixpanelService
	var mixpanelService: MixpanelService {
		return _mixpanelService
	}

	var services: [Service] {
		var services: [Service] = []
		if let secureTransferService = secureTransferService {
			services.append(secureTransferService)
		}
		services.append(transferService)
		services.append(mixpanelService)
		return services
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(String.self, forKey: .id)
		self.name = try container.decode(String.self, forKey: .name)
		self.icon = UIImage(named: try container.decode(String.self, forKey: .iconName))!

		let serverUrl = try container.decode(String.self, forKey: .serverUrl)
		let serverApiKey = try container.decode(String.self, forKey: .serverApiKey)
		self._transferService = TransferService(config: TransferService.Config(url: serverUrl, apiKey: serverApiKey))

		let mixpanelApiKey = try container.decode(String.self, forKey: .mixpanelApiKey)
		self._mixpanelService = MixpanelService(config: MixpanelService.Config(apiKey: mixpanelApiKey))

		let secureServerUrl = try container.decodeIfPresent(String.self, forKey: .secureServerUrl)
		let secureServerApiKey = try container.decodeIfPresent(String.self, forKey: .secureServerApiKey)
		if let url = secureServerUrl, let apiKey = secureServerApiKey {
			self._secureTransferService = TransferService(config: TransferService.Config(url: url, apiKey: apiKey, isSecure: true))
		}
	}
}
