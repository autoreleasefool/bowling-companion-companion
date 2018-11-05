//
//  MixpanelService.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-11-03.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import Foundation

class MixpanelService: Service {
	let apiKey: String
	let numberOfRequests: Int = 2

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

	func requestDailyActiveUsers(completion: @escaping () -> Void) {
		let dauRequest = buildURLRequest(for: dailyActiveUsersQuery)
		let task = URLSession.shared.dataTask(with: dauRequest) { [weak self] data, response, error in
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
		}

		DispatchQueue.global().async {
			task.resume()
		}
	}

	func requestMonthlyActiveUsers(completion: @escaping () -> Void) {
		let mauRequest = buildURLRequest(for: monthlyActiveUsersQuery)
		let task = URLSession.shared.dataTask(with: mauRequest) { [weak self] data, response, error in
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
		}

		DispatchQueue.global().async {
			task.resume()
		}
	}
}