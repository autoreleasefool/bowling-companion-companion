//
//  AdmobBuilder.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-12-01.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import FunctionalTableData

struct AdmobBuilder {
	static func section(service: AdmobService) -> TableSection {
		var cells: [CellConfigType] = []

		return TableSection(
			key: "admob-\(service.config.publisherId)-\(service.config.clientId)",
			rows: cells
		)
	}
}
