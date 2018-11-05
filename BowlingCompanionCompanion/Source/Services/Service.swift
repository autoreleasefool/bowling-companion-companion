//
//  Service.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-11-03.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import Foundation

protocol Service {
	var numberOfRequests: Int { get }
	func query(delegate: URLSessionDelegate, completion: @escaping () -> Void)
}
