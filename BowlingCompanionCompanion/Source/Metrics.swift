//
//  Metrics.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-10-28.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import CoreGraphics

struct Metrics {

	struct Spacing {
		static let base: CGFloat = 8.0
		static let small: CGFloat = base / 2.0
		static let tiny: CGFloat = base / 4.0
		static let large: CGFloat = base * 2.0
	}

	struct TextSize {
		static let caption: CGFloat = 12.0
		static let body: CGFloat = 14.0
		static let subtitle: CGFloat = 18.0
		static let title: CGFloat = 20.0
	}

	struct IconSize {
		static let standard: CGFloat = 44.0
		static let header: CGFloat = 48.0
	}
}
