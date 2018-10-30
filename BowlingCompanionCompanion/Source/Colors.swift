//
//  Colors.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-10-28.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import UIKit

extension UIColor {
	convenience init(hexString: String, alpha: CGFloat = 1.0) {
		var hexInt: UInt32 = 0
		let scanner = Scanner(string: hexString)
		scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
		scanner.scanHexInt32(&hexInt)

		let red = CGFloat((hexInt & 0xff0000) >> 16) / 255.0
		let green = CGFloat((hexInt & 0xff00) >> 8) / 255.0
		let blue = CGFloat((hexInt & 0xff) >> 0) / 255.0

		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}
}

struct Colors {

	public struct Text {
		static let primaryWhite = UIColor.white
		static let primaryBlack = UIColor.black
	}

	static let primary = UIColor(hexString: "#5F27CD")
	static let primaryDark = UIColor(hexString: "#341F97")
	static let primaryLight = UIColor(hexString: "#7B3DF4")

	static let background = UIColor(hexString: "#F5F5F5")
	static let disabled = UIColor(hexString: "#9B9B9B")

	static let listItem = UIColor(hexString: "#EBEBEB")
	static let divider = UIColor(hexString: "#000000", alpha: 0.2)

	static let affirmativeGreen = UIColor(hexString: "#27AE60")
	static let dangerRed = UIColor(hexString: "#EE5253")
	static let warningYellow = UIColor(hexString: "#F1C40F")
	static let infoBlue = UIColor(hexString: "#3498DB")
}
