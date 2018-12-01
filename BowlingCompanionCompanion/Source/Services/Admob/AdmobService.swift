//
//  AdmobService.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-12-01.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import Foundation
import FunctionalTableData

class AdmobService: Service {
	struct Config: Decodable {
		enum CodingKeys: String, CodingKey {
			case publisherId = "PublisherID"
			case clientId = "ClientID"
			case unitIds = "UnitIDs"
		}

		let publisherId: String
		let clientId: String
		let unitIds: [String]

		init(from container: KeyedDecodingContainer<CodingKeys>) throws {
			publisherId = try container.decode(String.self, forKey: .publisherId)
			clientId = try container.decode(String.self, forKey: .clientId)
			unitIds = try container.decode([String].self, forKey: .unitIds)
		}
	}

	let config: Config

	init(config: Config) {
		self.config = config
	}

	func query(delegate: URLSessionDelegate, completion: @escaping () -> Void) {

	}

	func section() -> TableSection {
		return AdmobBuilder.section(service: self)
	}
}
