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
		let headerLabel = SectionHeaderCell(
			key: "header",
			style: CellStyle(topSeparator: .full, separatorColor: Colors.divider),
			state: SectionHeaderCellState(title: "Usage"),
			cellUpdater: SectionHeaderCellState.updateView
		)

		let dauLabel = PaddedLabelCell(
			key: "dau",
			style: CellStyle(bottomSeparator: .inset, separatorColor: Colors.divider),
			state: LabelState(text: "\(service.dailyActiveUsers) daily active users"),
			cellUpdater: LabelState.updateView
		)
		let mauLabel = PaddedLabelCell(
			key: "mau",
			style: CellStyle(bottomSeparator: .full, separatorColor: Colors.divider),
			state: LabelState(text: "\(service.monthlyActiveUsers) monthly active users"),
			cellUpdater: LabelState.updateView
		)

		return TableSection(key: "usage-\(service.apiKey)", rows: [
			headerLabel,
			dauLabel,
			mauLabel,
			SpacerCell(key: "spacer", state: SpacerState(height: Metrics.Spacing.large), cellUpdater: SpacerState.updateView)
			])
	}
}
