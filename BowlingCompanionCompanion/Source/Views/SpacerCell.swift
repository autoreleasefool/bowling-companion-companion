//
//  SpacerCell.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-10-30.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

class SpacerView: UIView {
	private var heightConstraint: NSLayoutConstraint? = nil
	fileprivate var height: CGFloat = -1 {
		didSet {
			heightConstraint?.isActive = false

			if height > -1 {
				heightConstraint = heightAnchor.constraint(equalToConstant: height)
				heightConstraint?.isActive = true
			}
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = Colors.background
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

struct SpacerState: Equatable {
	private let height: CGFloat

	init(height: CGFloat) {
		self.height = height
	}

	public static func updateView(_ view: SpacerView, state: SpacerState?) {
		guard let state = state else { view.height = -1; return }
		view.height = state.height
	}

	public static func ==(lhs: SpacerState, rhs: SpacerState) -> Bool {
		return lhs.height == rhs.height
	}
}

typealias SpacerCell = HostCell<SpacerView, SpacerState, EdgeBasedTableItemLayout>
