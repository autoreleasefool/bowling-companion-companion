//
//  AppListBuilder.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-10-28.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import FunctionalTableData

protocol AppListActionable: class {
	func viewApp(app: App)
}

struct AppListBuilder {
	static func sections(apps: [App], actionable: AppListActionable) -> [TableSection] {
		let appCells: [CellConfigType] = apps.map { app in
			return AppItemCell(
				key: app.id,
				style: CellStyle(bottomSeparator: .inset, separatorColor: Colors.divider, highlight: true, accessoryType: .disclosureIndicator, backgroundColor: Colors.listItem),
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.viewApp(app: app)
					return .deselected
				}),
				state: AppItemCellState(app: app),
				cellUpdater: AppItemCellState.updateView
			)
		}

		return [TableSection(key: "apps", rows: appCells)]
	}
}
