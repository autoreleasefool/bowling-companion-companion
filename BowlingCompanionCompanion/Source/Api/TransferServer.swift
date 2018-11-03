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
	case partiallyOnline = "Partial"
	case waiting = "Waiting"
	case error = "Error"
}

struct TransferServerEndpoint: Decodable {
	let name: String
	let status: Bool
}

class TransferServer {
	private let url: URL
	private let apiKey: String

	private(set) var status: TransferServerStatus = .waiting
	private(set) var lastStatusCheck: TimeInterval = 0
	private(set) var endpoints: [TransferServerEndpoint] = []

	init(url: String, apiKey: String) {
		self.url = URL(string: url)!
		self.apiKey = apiKey
	}

	var statusEndpoint: URL {
		return URL(string: "api", relativeTo: url)!
	}

	var restartEndpoint: URL {
		return URL(string: "restart", relativeTo: url)!
	}

	private func buildURLRequest(for url: URL) -> URLRequest {
		var urlRequest = URLRequest(url: url)
		urlRequest.addValue(apiKey, forHTTPHeaderField: "Authorization")
		urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
		return urlRequest
	}

	func restart(urlSessionDelegate delegate: URLSessionDelegate, completion: @escaping () -> Void) {
		let restartRequest = buildURLRequest(for: restartEndpoint)
		let session = URLSession(configuration: URLSessionConfiguration.default, delegate: delegate, delegateQueue: OperationQueue.main)
		let task = session.dataTask(with: restartRequest) { [weak self] data, response, error in
			if let data = data, let body = String(data: data, encoding: .utf8) {
				if body != "OK" {
					print("Server failed to restart")
				}
			} else {
				if let error = error {
					print("Error restarting server: \(error)")
				}
				print("Server failed to restart")
			}

			DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
				self?.queryStatus(urlSessionDelegate: delegate, completion: completion)
			}
		}

		DispatchQueue.global().async {
			task.resume()
		}
	}

	func queryStatus(urlSessionDelegate delegate: URLSessionDelegate, completion: @escaping () -> Void) {
		let queryRequest = buildURLRequest(for: statusEndpoint)
		let session = URLSession(configuration: URLSessionConfiguration.default, delegate: delegate, delegateQueue: OperationQueue.main)
		let task = session.dataTask(with: queryRequest) { [weak self] data, response, error in
			guard let self = self else { return }
			self.lastStatusCheck = Date().timeIntervalSince1970

			let decoder = JSONDecoder()
			do {
				if let data = data {
					let	endpoints = try decoder.decode([TransferServerEndpoint].self, from: data)
					self.endpoints = endpoints
					if endpoints.count > 0 && endpoints.allSatisfy({ $0.status == true }) {
						self.status = .online
					} else {
						self.status = .partiallyOnline
					}
				} else if let error = error {
					self.status = .error
					print("Error accessing server: \(error)")
				} else {
					self.status = .offline
				}
			} catch let error {
				print("Error decoding server response: \(error)")
				self.status = .error
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
