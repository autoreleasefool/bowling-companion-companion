//
//  TransferServer.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-10-29.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import Foundation

enum TransferServerStatus: String, Codable {
	case online = "Online"
	case offline = "Offline"
	case waiting = "Waiting"
	case error = "Error"
}

class TransferServer {
	private let url: URL
	private let apiKey: String
	private(set) var status: TransferServerStatus = .waiting

	init(url: String, apiKey: String) {
		self.url = URL(string: url)!
		self.apiKey = apiKey
	}

	var statusEndpoint: URL {
		return url.appendingPathComponent("status")
	}

	var resetEndpoint: URL {
		return url.appendingPathComponent("reset")
	}

	private func buildURLRequest(for url: URL) -> URLRequest {
		var urlRequest = URLRequest(url: url)
		urlRequest.addValue(apiKey, forHTTPHeaderField: "Authorization")
		return urlRequest
	}

	func queryStatus(completion: @escaping () -> Void) {
		let queryRequest = buildURLRequest(for: statusEndpoint)
		let task = URLSession.shared.dataTask(with: queryRequest) { [weak self] data, response, error in
			if let data = data, let response = String(data: data, encoding: .utf8) {
				if response == "OK" {
					self?.status = .online
				} else {
					self?.status = .offline
				}
			} else {
				self?.status = .error
			}

			DispatchQueue.main.async {
				completion()
			}
		}

		DispatchQueue.global(qos: .background).async {
			task.resume()
		}
	}
}
