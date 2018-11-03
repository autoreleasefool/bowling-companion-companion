//
//  AppDetailsBuilder.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-10-30.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import FunctionalTableData

protocol AppDetailsActionable: class {
	func resetTransferServer()
}

struct AppDetailsBuilder {
	static func sections(app: App, actionable: AppDetailsActionable) -> [TableSection] {
		return [
			Image.section(app: app),
			Server.section(endpoints: app.transferServer.endpoints, actionable: actionable),
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
		static func section(endpoints: [TransferServerEndpoint], actionable: AppDetailsActionable) -> TableSection {
			var rows: [CellConfigType] = [
				SectionHeaderCell(
					key: "server-header",
					style: CellStyle(topSeparator: .full, separatorColor: Colors.divider, highlight: true, selectionColor: Colors.primaryLight, backgroundColor: Colors.primaryDark),
					actions: CellActions(selectionAction: { [weak actionable] _ in
						actionable?.resetTransferServer()
						return .deselected
					}),
					state: SectionHeaderCellState(title: "Transfer server", actionIcon: UIImage(named: "Reset")!),
					cellUpdater: SectionHeaderCellState.updateView
				)
			]

			endpoints.forEach { endpoint in
				let backgroundColor = endpoint.status ? Colors.affirmativeGreen : Colors.dangerRed
				rows.append(PaddedLabelCell(
					key: endpoint.name,
					style: CellStyle(bottomSeparator: .inset, separatorColor: Colors.divider),
					state: LabelState(text: endpoint.name, textColor: Colors.Text.primaryWhite, backgroundColor: backgroundColor),
					cellUpdater: LabelState.updateView
				))
			}

			if rows.count <= 1 {
				rows.append(PaddedLabelCell(
					key: "no-endpoints",
					style: CellStyle(bottomSeparator: .inset, separatorColor: Colors.divider),
					state: LabelState(text: "No endpoint data", textColor: Colors.Text.primaryBlack),
					cellUpdater: LabelState.updateView
				))
			}

			rows[rows.endIndex - 1].style?.bottomSeparator = .full
			rows[rows.endIndex - 1].style?.separatorColor = Colors.divider

			rows.append(SpacerCell(key: "server-spacer", state: SpacerState(height: Metrics.Spacing.large), cellUpdater: SpacerState.updateView))

			return TableSection(key: "server", rows: rows)
		}
	}

	struct Usage {
		static func section() -> TableSection {
			let headerLabel = SectionHeaderCell(
				key: "usage-header",
				style: CellStyle(topSeparator: .full, separatorColor: Colors.divider),
				state: SectionHeaderCellState(title: "Usage"),
				cellUpdater: SectionHeaderCellState.updateView
			)

			let dauLabel = PaddedLabelCell(
				key: "usage-dau",
				style: CellStyle(bottomSeparator: .inset, separatorColor: Colors.divider),
				state: LabelState(text: "256 daily active users"),
				cellUpdater: LabelState.updateView
			)
			let mauLabel = PaddedLabelCell(
				key: "usage-mau",
				style: CellStyle(bottomSeparator: .full, separatorColor: Colors.divider),
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
				style: CellStyle(topSeparator: .full, bottomSeparator: .full, highlight: true, selectionColor: Colors.primaryLight, backgroundColor: Colors.primaryDark),
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
