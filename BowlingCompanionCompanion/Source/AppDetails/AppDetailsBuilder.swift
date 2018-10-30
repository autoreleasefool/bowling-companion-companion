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
		return [
			Image.section(app: app),
			Server.section(),
			Usage.section(),
			Errors.section(),
		]
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

	struct Server {
		static func section() -> TableSection {
			let headerLabel = PaddedLabelCell(
				key: "server-header",
				state: LabelState(text: "Transfer server", textColor: Colors.Text.primaryWhite, backgroundColor: Colors.primaryDark, textSize: Metrics.TextSize.subtitle),
				cellUpdater: LabelState.updateView
			)

			let apiLabel = PaddedLabelCell(
				key: "server-api",
				state: LabelState(text: "API Endpoints", textColor: Colors.Text.primaryWhite, backgroundColor: Colors.affirmativeGreen),
				cellUpdater: LabelState.updateView
			)
			let databaseLabel = PaddedLabelCell(
				key: "server-database",
				state: LabelState(text: "MongoDB", textColor: Colors.Text.primaryWhite, backgroundColor: Colors.dangerRed),
				cellUpdater: LabelState.updateView
			)
			let cronLabel = PaddedLabelCell(
				key: "server-cron",
				state: LabelState(text: "Cron", textColor: Colors.Text.primaryWhite, backgroundColor: Colors.affirmativeGreen),
				cellUpdater: LabelState.updateView
			)

			return TableSection(key: "server", rows: [
				headerLabel,
				apiLabel,
				databaseLabel,
				cronLabel
				])
		}
	}

	struct Usage {
		static func section() -> TableSection {
			let headerLabel = PaddedLabelCell(
				key: "usage-header",
				state: LabelState(text: "Usage", textColor: Colors.Text.primaryWhite, backgroundColor: Colors.primaryDark, textSize: Metrics.TextSize.subtitle),
				cellUpdater: LabelState.updateView
			)

			let dauLabel = PaddedLabelCell(
				key: "usage-dau",
				style: CellStyle(bottomSeparator: .inset),
				state: LabelState(text: "256 daily active users"),
				cellUpdater: LabelState.updateView
			)
			let mauLabel = PaddedLabelCell(
				key: "usage-mau",
				state: LabelState(text: "1,018 monthly active users"),
				cellUpdater: LabelState.updateView
			)

			return TableSection(key: "usage", rows: [
				headerLabel,
				dauLabel,
				mauLabel
				])
		}
	}

	struct Errors {
		static func section() -> TableSection {
			let headerLabel = PaddedLabelCell(
				key: "errors-header",
				state: LabelState(text: "Errors", textColor: Colors.Text.primaryWhite, backgroundColor: Colors.primaryDark, textSize: Metrics.TextSize.subtitle),
				cellUpdater: LabelState.updateView
			)

			return TableSection(key: "errors", rows: [headerLabel])
		}
	}
}
