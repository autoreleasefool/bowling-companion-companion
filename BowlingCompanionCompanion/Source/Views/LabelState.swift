//
//  LabelState.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-10-30.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import UIKit
import Foundation
import FunctionalTableData

struct LabelState: Equatable {
	let text: String
	let textColor: UIColor
	let backgroundColor: UIColor
	let textSize: CGFloat
	
	init(text: String, textColor: UIColor = Colors.Text.primaryBlack, backgroundColor: UIColor = UIColor.white, textSize: CGFloat = Metrics.TextSize.body) {
		self.text = text
		self.textColor = textColor
		self.textSize = textSize
		self.backgroundColor = backgroundColor
	}

	public static func updateView(_ view: UILabel, state: LabelState?) {
		guard let state = state else {
			view.text = nil
			view.backgroundColor = UIColor.white
			return
		}

		if let paddedView = view as? PaddedLabel {
			paddedView.padding = UIEdgeInsets(top: Metrics.Spacing.base, left: Metrics.Spacing.large, bottom: Metrics.Spacing.base, right: Metrics.Spacing.large)
		}

		view.text = state.text
		view.textColor = state.textColor
		view.backgroundColor = state.backgroundColor
		view.font = UIFont(name: view.font.fontName, size: state.textSize)
	}

	public static func ==(lhs: LabelState, rhs: LabelState) -> Bool {
		return lhs.text == rhs.text &&
			lhs.textColor == rhs.textColor &&
			lhs.textSize == rhs.textSize &&
			lhs.backgroundColor == rhs.backgroundColor
	}
}

typealias LabelCell = HostCell<UILabel, LabelState, EdgeBasedTableItemLayout>
typealias PaddedLabelCell = HostCell<PaddedLabel, LabelState, EdgeBasedTableItemLayout>
