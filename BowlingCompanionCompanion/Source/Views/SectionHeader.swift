//
//  SectionHeader.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-10-30.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

class SectionHeaderCellView: UIView {
	fileprivate let titleLabel = UILabel()
	fileprivate let iconView = UIImageView()
	fileprivate let actionLabel = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)

		backgroundColor = Colors.primaryLight

		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		iconView.translatesAutoresizingMaskIntoConstraints = false
		actionLabel.translatesAutoresizingMaskIntoConstraints = false

		titleLabel.font = UIFont.systemFont(ofSize: Metrics.TextSize.subtitle)
		titleLabel.textColor = Colors.Text.primaryWhite

		actionLabel.font = UIFont.systemFont(ofSize: Metrics.TextSize.caption)
		actionLabel.textColor = Colors.Text.primaryWhite

		iconView.contentMode = .scaleAspectFit
		iconView.tintColor = UIColor.white

		addSubview(titleLabel)
		addSubview(iconView)
		addSubview(actionLabel)

		iconView.isUserInteractionEnabled = true
		actionLabel.isUserInteractionEnabled = true

		NSLayoutConstraint.activate([
			heightAnchor.constraint(greaterThanOrEqualToConstant: Metrics.IconSize.action + Metrics.Spacing.large * 2),

			titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.Spacing.large),

			iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
			iconView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.Spacing.large),
			iconView.widthAnchor.constraint(equalToConstant: Metrics.IconSize.action),
			iconView.heightAnchor.constraint(equalToConstant: Metrics.IconSize.action),

			actionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
			actionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.Spacing.large)
			])
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

struct SectionHeaderCellState: Equatable {
	private let title: String
	private let actionIcon: UIImage?
	private let actionText: String?

	init(title: String, actionIcon: UIImage? = nil, actionText: String? = nil) {
		self.title = title
		self.actionIcon = actionIcon
		self.actionText = actionText
	}

	public static func updateView(_ view: SectionHeaderCellView, state: SectionHeaderCellState?) {
		guard let state = state else {
			view.titleLabel.text = nil
			view.iconView.image = nil
			view.actionLabel.text = nil
			return
		}

		view.titleLabel.text = state.title
		view.iconView.image = state.actionIcon
		view.actionLabel.text = state.actionText
	}

	public static func ==(lhs: SectionHeaderCellState, rhs: SectionHeaderCellState) -> Bool {
		return lhs.title == rhs.title &&
			lhs.actionIcon == rhs.actionIcon &&
			lhs.actionText == rhs.actionText
	}
}

typealias SectionHeaderCell = HostCell<SectionHeaderCellView, SectionHeaderCellState, EdgeBasedTableItemLayout>
