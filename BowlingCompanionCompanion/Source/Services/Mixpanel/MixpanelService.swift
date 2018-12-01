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
	struct Config: Decodable {
		enum CodingKeys: String, CodingKey {
			case apiKey = "ApiKey"
		}

		let apiKey: String

		init(from container: KeyedDecodingContainer<CodingKeys>) throws {
			apiKey = try container.decode(String.self, forKey: .apiKey)
		}
	}

	let config: Config

	private(set) var dailyActiveUsers: Int? = nil
	private(set) var monthlyActiveUsers: Int? = nil

	private var url: URL {
		return URL(string: "https://\(config.apiKey):@mixpanel.com/api/2.0/jql")!
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

	init(config: Config) {
		self.config = config
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
		return MixpanelBuilder.section(service: self)
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
