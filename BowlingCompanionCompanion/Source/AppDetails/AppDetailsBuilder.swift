//
//  AppDetailsBuilder.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-10-30.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import FunctionalTableData

struct AppDetailsBuilder {
	static func sections(app: App) -> [TableSection] {
		var sections = [Image.section(app: app)]
		app.services.forEach {
			sections.append($0.section())
		}
		return sections
	}

	struct Image {
		static func section(app: App) -> TableSection {
			let appImage = ImageCell(
				key: "appImage",
				style: CellStyle(backgroundColor: Colors.background, layoutMargins: UIEdgeInsets(top: Metrics.Spacing.large, left: Metrics.Spacing.large, bottom: Metrics.Spacing.large, right: Metrics.Spacing.large)),
				state: ImageState(image: app.icon, width: Metrics.IconSize.header, height: Metrics.IconSize.header),
				cellUpdater: ImageState.updateView
			)

			return TableSection(key: "image", rows: [appImage])
		}
	}
}
