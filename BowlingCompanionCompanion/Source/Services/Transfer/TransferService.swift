//
//  TransferService.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-10-29.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import Foundation
import FunctionalTableData

class TransferService: Service {
	struct Config: Decodable {
		enum CodingKeys: String, CodingKey {
			case url = "URL"
			case apiKey = "ApiKey"
		}

		let url: URL
		let apiKey: String

		init(from container: KeyedDecodingContainer<CodingKeys>) throws {
			url = URL(string: try container.decode(String.self, forKey: .url))!
			apiKey = try container.decode(String.self, forKey: .apiKey)
		}
	}

	enum Status: String {
		case online = "Online"
		case offline = "Offline"
		case partiallyOnline = "Partial"
		case waiting = "Waiting"
		case error = "Error"
	}

	struct Endpoint: Decodable {
		let name: String
		let status: Bool
	}

	let config: Config
	let isSecure: Bool
	private(set) var status: Status? = nil
	private(set) var endpoints: [Endpoint]? = nil

	init(config: Config, isSecure: Bool = false) {
		self.config = config
		self.isSecure = isSecure
	}

	private var statusEndpoint: URL {
		return URL(string: "api", relativeTo: config.url)!
	}

	private func buildURLRequest(for url: URL) -> URLRequest {
		var urlRequest = URLRequest(url: url)
		urlRequest.addValue(config.apiKey, forHTTPHeaderField: "Authorization")
		urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
		return urlRequest
	}

	func query(delegate: URLSessionDelegate, completion: @escaping () -> Void) {
		status = .waiting
		endpoints = []
		queryStatus(urlSessionDelegate: delegate, completion: completion)
	}

	func section() -> TableSection {
		return TransferBuilder.section(service: self)
	}

	func queryStatus(urlSessionDelegate delegate: URLSessionDelegate, completion: @escaping () -> Void) {
		let queryRequest = buildURLRequest(for: statusEndpoint)
		let session = URLSession(configuration: URLSessionConfiguration.default, delegate: delegate, delegateQueue: OperationQueue.main)
		session.dataTask(with: queryRequest) { [weak self] data, response, error in
			guard let self = self else { return }
			let decoder = JSONDecoder()
			do {
				if let data = data {
					let	endpoints = try decoder.decode([Endpoint].self, from: data)
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
		}.resume()
	}
}
