//
//  BugsnagService.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-11-03.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import Foundation
import FunctionalTableData

class BugsnagService: Service {

	struct Error: Decodable {
		private enum CodingKeys: String, CodingKey {
			case id = "id"
			case title = "error_class"
			case message = "message"
			case lastSeen = "last_seen"
			case numberOfEvents = "events"
			case numberOfUsers = "users"
		}

		let id: String
		let title: String
		let message: String
		let lastSeen: String
		let numberOfEvents: Int
		let numberOfUsers: Int
	}

	let apiKey: String
	let projectId: String

	var recentErrors: [Error] = []
	var dailyCrashes: Int = 0

	init(projectId: String, apiKey: String) {
		self.projectId = projectId
		self.apiKey = apiKey
	}

	private var url: URL {
		return URL(string: "https://api.bugsnag.com/")!
	}

	private var errorsUrl: URL {
		return URL(string: "projects/\(projectId)/errors", relativeTo: self.url)!
	}

	private func buildURLRequest(with components: URLComponents) -> URLRequest {
		var urlRequest = URLRequest(url: components.url!)
		urlRequest.addValue("2", forHTTPHeaderField: "X-Version")
		urlRequest.addValue("token \(apiKey)", forHTTPHeaderField: "Authorization")
		return urlRequest
	}

	func query(delegate: URLSessionDelegate, completion: @escaping () -> Void) {
		var components = URLComponents(string: errorsUrl.absoluteString)!
		components.queryItems = [
			URLQueryItem(name: "per_page", value: "3")
			]

		let recentErrorsRequest = buildURLRequest(with: components)
		URLSession.shared.dataTask(with: recentErrorsRequest) { [weak self] data, response, error in
			let decoder = JSONDecoder()
			do {
				if let data = data {
					let	errors = try decoder.decode([Error].self, from: data)
					self?.recentErrors = errors
				}
			} catch let error {
				print("Error decoding bugsnag response: \(error)")
			}

			DispatchQueue.main.async {
				completion()
			}
		}.resume()
	}

	func section() -> TableSection {
		return BugsnagService.section(service: self)
	}
}

extension BugsnagService {
	static func section(service: BugsnagService) -> TableSection {
		var cells: [CellConfigType] = []
		cells.append(SectionHeaderCell(
			key: "header",
			style: CellStyle(topSeparator: .full, highlight: true, selectionColor: Colors.primaryLight, backgroundColor: Colors.primaryDark),
			actions: CellActions(selectionAction: { _ in
				return .deselected
			}),
			state: SectionHeaderCellState(title: "Errors", actionText: "View all"),
			cellUpdater: SectionHeaderCellState.updateView
		))

		service.recentErrors.forEach { error in
			cells.append(ErrorCell(
				key: error.id,
				style: CellStyle(bottomSeparator: .inset, separatorColor: Colors.divider, highlight: true),
				actions: CellActions(selectionAction: { _ in
					return .deselected
				}),
				state: ErrorCellState(title: error.title, message: error.message, time: Date(), numberOfEvents: error.numberOfEvents, numberOfUsers: error.numberOfUsers),
				cellUpdater: ErrorCellState.updateView
			))
		}

		if cells.count <= 1 {
			cells.append(PaddedLabelCell(
				key: "no-errors",
				style: CellStyle(bottomSeparator: .inset, separatorColor: Colors.divider),
				state: LabelState(text: "No errors found", textColor: Colors.Text.primaryBlack),
				cellUpdater: LabelState.updateView
			))
		}

		cells[cells.endIndex - 1].style?.bottomSeparator = .full
		cells[cells.endIndex - 1].style?.separatorColor = Colors.divider

		cells.append(SpacerCell(key: "spacer", state: SpacerState(height: Metrics.Spacing.large), cellUpdater: SpacerState.updateView))

		return TableSection(key: "errors-\(service.projectId)", rows: cells)
	}
}
