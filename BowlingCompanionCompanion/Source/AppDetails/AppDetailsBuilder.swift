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
			let headerLabel = SectionHeaderCell(
				key: "server-header",
				state: SectionHeaderCellState(title: "Transfer server"),
				cellUpdater: SectionHeaderCellState.updateView
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
				cronLabel,
				SpacerCell(key: "server-spacer", state: SpacerState(height: Metrics.Spacing.large), cellUpdater: SpacerState.updateView)
				])
		}
	}

	struct Usage {
		static func section() -> TableSection {
			let headerLabel = SectionHeaderCell(
				key: "usage-header",
				state: SectionHeaderCellState(title: "Usage"),
				cellUpdater: SectionHeaderCellState.updateView
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
				mauLabel,
				SpacerCell(key: "server-spacer", state: SpacerState(height: Metrics.Spacing.large), cellUpdater: SpacerState.updateView)
				])
		}
	}

	struct Errors {
		static func section() -> TableSection {
			let headerLabel = SectionHeaderCell(
				key: "errors-header",
				style: CellStyle(highlight: true, selectionColor: Colors.primaryLight, backgroundColor: Colors.primaryDark),
				actions: CellActions(selectionAction: { _ in
					return .deselected
				}),
				state: SectionHeaderCellState(title: "Errors", actionText: "View all"),
				cellUpdater: SectionHeaderCellState.updateView
			)

			return TableSection(key: "errors", rows: [headerLabel, SpacerCell(key: "server-spacer", state: SpacerState(height: Metrics.Spacing.large), cellUpdater: SpacerState.updateView)])
		}
	}
}
