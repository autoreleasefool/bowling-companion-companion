//
//  AppListBuilder.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-10-28.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import FunctionalTableData

struct AppListBuilder {
	static func sections() -> [TableSection] {
		let appCells: [CellConfigType] = [
			AppItemCell(
				key: "fivePin",
				style: CellStyle(bottomSeparator: .inset, separatorColor: Colors.divider, highlight: true, accessoryType: .disclosureIndicator, backgroundColor: Colors.background),
				actions: CellActions(selectionAction: { _ in
					return .deselected
				}),
				state: AppItemCellState(
					appIcon: UIImage(named: "FivePin")!,
					appName: "5 Pin Bowling Companion",
					dailyActiveUsers: 0,
					crashes: 0,
					serverOnline: true
				),
				cellUpdater: AppItemCellState.updateView
			)
		]

		return [TableSection(key: "apps", rows: appCells)]
	}
}
