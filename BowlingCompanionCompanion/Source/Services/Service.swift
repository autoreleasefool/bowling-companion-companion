//
//  Service.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-11-03.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import Foundation
import FunctionalTableData

protocol Service {
	func query(delegate: URLSessionDelegate, completion: @escaping () -> Void)
	func section() -> TableSection
}
