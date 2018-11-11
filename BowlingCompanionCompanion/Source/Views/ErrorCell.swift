//
//  ErrorCell.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-11-08.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

class ErrorCellView: UIView {
	fileprivate let titleLabel = UILabel()
	fileprivate let messageLabel = UILabel()
	fileprivate let timeLabel = UILabel()
	fileprivate let eventsLabel = UILabel()
	fileprivate let usersLabel = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)

		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.font = UIFont.boldSystemFont(ofSize: Metrics.TextSize.body)
		titleLabel.textColor = Colors.Text.primaryBlack
		titleLabel.numberOfLines = 0

		messageLabel.translatesAutoresizingMaskIntoConstraints = false
		messageLabel.font = UIFont.systemFont(ofSize: Metrics.TextSize.body)
		messageLabel.textColor = Colors.Text.primaryBlack
		messageLabel.numberOfLines = 0

		timeLabel.translatesAutoresizingMaskIntoConstraints = false
		timeLabel.font = UIFont.systemFont(ofSize: Metrics.TextSize.caption)
		timeLabel.textColor = Colors.Text.primaryBlack
		timeLabel.numberOfLines = 0

		eventsLabel.translatesAutoresizingMaskIntoConstraints = false
		eventsLabel.font = UIFont.systemFont(ofSize: Metrics.TextSize.body)
		eventsLabel.textColor = Colors.Text.primaryBlack

		usersLabel.translatesAutoresizingMaskIntoConstraints = false
		usersLabel.font = UIFont.systemFont(ofSize: Metrics.TextSize.body)
		usersLabel.textColor = Colors.Text.primaryBlack

		addSubview(titleLabel)
		addSubview(messageLabel)
		addSubview(timeLabel)
//		addSubview(eventsLabel)
//		addSubview(usersLabel)

		NSLayoutConstraint.activate([
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.Spacing.large),
			titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.Spacing.base),
			titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.Spacing.large),

			messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.Spacing.large),
			messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.Spacing.base),
			messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.Spacing.large),

			timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.Spacing.large),
			timeLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: Metrics.Spacing.base),
			timeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.Spacing.base),
			timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.Spacing.large),
			])
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

struct ErrorCellState: Equatable {
	private let title: String
	private let message: String
	private let time: Date
	private let numberOfEvents: Int
	private let numberOfUsers: Int

	init(title: String, message: String, time: Date, numberOfEvents: Int, numberOfUsers: Int) {
		self.title = title
		self.message = message
		self.time = time
		self.numberOfEvents = numberOfEvents
		self.numberOfUsers = numberOfUsers
	}

	public static func updateView(_ view: ErrorCellView, state: ErrorCellState?) {
		guard let state = state else {
			view.titleLabel.text = nil
			view.messageLabel.text = nil
			view.timeLabel.text = nil
			view.eventsLabel.text = nil
			view.usersLabel.text = nil
			return
		}

		view.titleLabel.text = state.title
		view.messageLabel.text = state.message
		view.timeLabel.text = "Time TBD"
		view.eventsLabel.text = "\(state.numberOfEvents) events"
		view.usersLabel.text = "\(state.numberOfUsers) users"
	}

	public static func ==(lhs: ErrorCellState, rhs: ErrorCellState) -> Bool {
		return lhs.title == rhs.title &&
			lhs.message == rhs.message &&
			lhs.time == rhs.time &&
			lhs.numberOfEvents == rhs.numberOfEvents &&
			lhs.numberOfUsers == rhs.numberOfUsers
	}
}

typealias ErrorCell = HostCell<ErrorCellView, ErrorCellState, EdgeBasedTableItemLayout>
