//
//  MixpanelService.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-11-03.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import Foundation
import FunctionalTableData

class MixpanelService: Service {
	let apiKey: String

	private(set) var dailyActiveUsers: Int = 0
	private(set) var monthlyActiveUsers: Int = 0

	private var url: URL {
		return URL(string: "https://\(apiKey):@mixpanel.com/api/2.0/jql")!
	}

	private var dailyActiveUsersQuery: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let currentDate = Date()

		return """
		function main() {
			return Events({
				from_date: "\(dateFormatter.string(from: currentDate))",
				to_date: "\(dateFormatter.string(from: currentDate))",
				event_selectors: [{ event: "Bowlers - Select" }]
			}).groupByUser(() => 0)
			.reduce(mixpanel.reducer.count());
		}
		"""
	}

	private var monthlyActiveUsersQuery: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"

		let calendar = Calendar(identifier: .gregorian)
		let currentDate = Date()
		let components = calendar.dateComponents(Set([.year, .month]), from: currentDate)
		let startOfMonth = calendar.date(from: components)!

		return """
			function main() {
				return Events({
					from_date: "\(dateFormatter.string(from: startOfMonth))",
					to_date: "\(dateFormatter.string(from: currentDate))",
					event_selectors: [{ event: "Bowlers - Select" }]
				}).groupByUser(() => 0)
				.reduce(mixpanel.reducer.count());
			}
			"""
	}

	init(apiKey: String) {
		self.apiKey = apiKey
	}

	private func buildURLRequest(for script: String) -> URLRequest {
		var urlRequest = URLRequest(url: self.url)
		urlRequest.httpMethod = "POST"
		urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: ["script": script], options: [])
		return urlRequest
	}

	func query(delegate: URLSessionDelegate, completion: @escaping () -> Void) {
		requestDailyActiveUsers(completion: completion)
		requestMonthlyActiveUsers(completion: completion)
	}

	func section() -> TableSection {
		return MixpanelService.section(service: self)
	}

	func requestDailyActiveUsers(completion: @escaping () -> Void) {
		let dauRequest = buildURLRequest(for: dailyActiveUsersQuery)
		URLSession.shared.dataTask(with: dauRequest) { [weak self] data, response, error in
			let decoder = JSONDecoder()
			do {
				if let data = data {
					let	users = try decoder.decode([Int].self, from: data)
					self?.dailyActiveUsers = users[0]
				}
			} catch let error {
				print("Error decoding mixpanel response: \(error)")
			}

			DispatchQueue.main.async {
				completion()
			}
		}.resume()
	}

	func requestMonthlyActiveUsers(completion: @escaping () -> Void) {
		let mauRequest = buildURLRequest(for: monthlyActiveUsersQuery)
		URLSession.shared.dataTask(with: mauRequest) { [weak self] data, response, error in
			let decoder = JSONDecoder()
			do {
				if let data = data {
					let	users = try decoder.decode([Int].self, from: data)
					self?.monthlyActiveUsers = users[0]
				}
			} catch let error {
				print("Error decoding mixpanel response: \(error)")
			}

			DispatchQueue.main.async {
				completion()
			}
		}.resume()
	}
}

extension MixpanelService {
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

		return TableSection(key: "usage-\(service.url)", rows: [
			headerLabel,
			dauLabel,
			mauLabel,
			SpacerCell(key: "spacer", state: SpacerState(height: Metrics.Spacing.large), cellUpdater: SpacerState.updateView)
			])
	}
}
