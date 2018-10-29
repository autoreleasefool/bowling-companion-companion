//
//  App.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-10-28.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import UIKit

class App: Equatable, Hashable {

	let id: String

	let name: String
	let icon: UIImage

	var dailyActiveUsers: Int = 0
	var monthlyActiveUsers: Int = 0

	var crashes: Int = 0

	var serverOnline: Bool = false

	init(id: String, name: String, iconName: String) {
		self.id = id
		self.icon = UIImage(named: iconName)!
		self.name = name
	}

	public static func ==(lhs: App, rhs: App) -> Bool {
		return lhs.id == rhs.id
	}

	public var hashValue: Int {
		return id.hashValue
	}
}
