//
//  TransferBuilder.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-11-18.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import FunctionalTableData

struct TransferBuilder {
	static func section(service: TransferService) -> TableSection {
		var sectionTitle: String = "Transfer service"
		if service.config.isSecure {
			sectionTitle += " (SSL)"
		}

		var cells: [CellConfigType] = [
			SectionHeaderCell(
				key: "header",
				style: CellStyle(topSeparator: .full, separatorColor: Colors.divider),
				state: SectionHeaderCellState(title: sectionTitle),
				cellUpdater: SectionHeaderCellState.updateView
			)
		]

		if let endpoints = service.endpoints {
			endpoints.forEach { endpoint in
				let backgroundColor = endpoint.status ? Colors.affirmativeGreen : Colors.dangerRed
				cells.append(PaddedLabelCell(
					key: endpoint.name,
					style: CellStyle(bottomSeparator: .inset, separatorColor: Colors.divider),
					state: LabelState(text: endpoint.name, textColor: Colors.Text.primaryWhite, backgroundColor: backgroundColor),
					cellUpdater: LabelState.updateView
				))
			}
		}

		if cells.count <= 1 {
			cells.append(PaddedLabelCell(
				key: "no-endpoints",
				style: CellStyle(bottomSeparator: .inset, separatorColor: Colors.divider),
				state: LabelState(text: "No endpoint data", textColor: Colors.Text.primaryBlack),
				cellUpdater: LabelState.updateView
			))
		}

		cells[cells.endIndex - 1].style?.bottomSeparator = .full
		cells[cells.endIndex - 1].style?.separatorColor = Colors.divider

		cells.append(SpacerCell(key: "spacer", state: SpacerState(height: Metrics.Spacing.large), cellUpdater: SpacerState.updateView))

		return TableSection(key: "\(service.config.apiKey)", rows: cells)
	}
}
