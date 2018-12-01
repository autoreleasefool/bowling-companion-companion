//
//  MixpanelBuilder.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-11-18.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import FunctionalTableData

struct MixpanelBuilder {
	static func section(service: MixpanelService) -> TableSection {
		var cells: [CellConfigType] = []

		cells.append(SectionHeaderCell(
			key: "header",
			style: CellStyle(topSeparator: .full, separatorColor: Colors.divider),
			state: SectionHeaderCellState(title: "Usage"),
			cellUpdater: SectionHeaderCellState.updateView
		))

		if let dau = service.dailyActiveUsers, let mau = service.monthlyActiveUsers {
			cells.append(PaddedLabelCell(
				key: "dau",
				style: CellStyle(bottomSeparator: .inset, separatorColor: Colors.divider),
				state: LabelState(text: "\(dau) daily active users"),
				cellUpdater: LabelState.updateView
			))
			cells.append(PaddedLabelCell(
				key: "mau",
				style: CellStyle(bottomSeparator: .full, separatorColor: Colors.divider),
				state: LabelState(text: "\(mau) monthly active users"),
				cellUpdater: LabelState.updateView
			))
		} else {
			cells.append(PaddedLabelCell(
				key: "no-data",
				style: CellStyle(bottomSeparator: .full, separatorColor: Colors.divider),
				state: LabelState(text: "Service unavailable"),
				cellUpdater: LabelState.updateView
			))
		}

		cells.append(SpacerCell(key: "spacer", state: SpacerState(height: Metrics.Spacing.large), cellUpdater: SpacerState.updateView))

		return TableSection(key: "usage-\(service.apiKey)", rows: cells)
	}
}
