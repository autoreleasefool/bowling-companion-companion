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
		case transferServer = "TransferServer"
		case secureTransferServer = "SecureTransferServer"
		case mixpanel = "Mixpanel"
		case admob = "Admob"
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

	private var _admobService: AdmobService
	var admobService: AdmobService {
		return _admobService
	}

	var services: [Service] {
		var services: [Service] = []
		if let secureTransferService = secureTransferService {
			services.append(secureTransferService)
		}
		services.append(transferService)
		services.append(mixpanelService)
		services.append(admobService)
		return services
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(String.self, forKey: .id)
		self.name = try container.decode(String.self, forKey: .name)
		self.icon = UIImage(named: try container.decode(String.self, forKey: .iconName))!

		let transferContainer = try container.nestedContainer(keyedBy: TransferService.Config.CodingKeys.self, forKey: .transferServer)
		let transferConfig = try TransferService.Config(from: transferContainer)
		self._transferService = TransferService(config: transferConfig)

		if container.contains(.secureTransferServer) {
			let secureTransferContainer = try container.nestedContainer(keyedBy: TransferService.Config.CodingKeys.self, forKey: .secureTransferServer)
			let secureTransferConfig = try TransferService.Config(from: secureTransferContainer)
			self._secureTransferService = TransferService(config: secureTransferConfig, isSecure: true)
		}

		let mixpanelContainer = try container.nestedContainer(keyedBy: MixpanelService.Config.CodingKeys.self, forKey: .mixpanel)
		let mixpanelConfig = try MixpanelService.Config(from: mixpanelContainer)
		self._mixpanelService = MixpanelService(config: mixpanelConfig)

		let admobContainer = try container.nestedContainer(keyedBy: AdmobService.Config.CodingKeys.self, forKey: .admob)
		let admobConfig = try AdmobService.Config(from: admobContainer)
		self._admobService = AdmobService(config: admobConfig)
	}
}
