//
//  AppItemView.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-10-28.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import Foundation
import FunctionalTableData

class AppItemCellView: UIView {
	fileprivate let imageView = UIImageView()
	fileprivate let titleLabel = UILabel()
	fileprivate let dauLabel = UILabel()
	fileprivate let crashesLabel = UILabel()
	fileprivate let statusLabel = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)

		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false

		titleLabel.textColor = UIColor.black
		titleLabel.font = UIFont(name: titleLabel.font.fontName, size: Metrics.TextSize.title)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false

		dauLabel.textColor = Colors.affirmativeGreen
		dauLabel.font = UIFont(name: dauLabel.font.fontName, size: Metrics.TextSize.body)
		dauLabel.translatesAutoresizingMaskIntoConstraints = false

		crashesLabel.textColor = Colors.dangerRed
		crashesLabel.font = UIFont(name: dauLabel.font.fontName, size: Metrics.TextSize.body)
		crashesLabel.translatesAutoresizingMaskIntoConstraints = false

		statusLabel.font = UIFont(name: dauLabel.font.fontName, size: Metrics.TextSize.body)
		statusLabel.translatesAutoresizingMaskIntoConstraints = false

		addSubview(imageView)
		addSubview(titleLabel)
		addSubview(dauLabel)
		addSubview(crashesLabel)
		addSubview(statusLabel)

		NSLayoutConstraint.activate([
			imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.Spacing.large),
			imageView.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.Spacing.large),
			imageView.widthAnchor.constraint(equalToConstant: Metrics.IconSize.standard),
			imageView.heightAnchor.constraint(equalToConstant: Metrics.IconSize.standard),
			imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.Spacing.large),

			titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Metrics.Spacing.base),
			titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
			titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.Spacing.large),

			dauLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Metrics.Spacing.base),
			dauLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.Spacing.small),

			crashesLabel.leadingAnchor.constraint(equalTo: dauLabel.trailingAnchor, constant: Metrics.Spacing.large),
			crashesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.Spacing.small),

			statusLabel.leadingAnchor.constraint(equalTo: crashesLabel.trailingAnchor, constant: Metrics.Spacing.large),
			statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.Spacing.small),
			])
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	fileprivate func prepareForReuse() {
		imageView.image = nil
		titleLabel.text = nil
		dauLabel.text = nil
		crashesLabel.text = nil
		statusLabel.text = nil
	}
}

struct AppItemCellState: Equatable {
	private let appIcon: UIImage
	private let appName: String
	private let dailyActiveUsers: Int
	private let crashes: Int
	private let serverStatus: TransferServerStatus

	init(app: App) {
		self.appIcon = app.icon
		self.appName = app.name
		self.dailyActiveUsers = app.dailyActiveUsers
		self.crashes = app.crashes
		self.serverStatus = app.transferServer.status
	}

	public static func updateView(_ view: AppItemCellView, state: AppItemCellState?) {
		guard let state = state else {
			view.prepareForReuse()
			return
		}

		view.imageView.image = state.appIcon
		view.titleLabel.text = state.appName
		view.dauLabel.text = "\(state.dailyActiveUsers) DAU"
		view.crashesLabel.text = "\(state.crashes) crashes"

		let statusColor: UIColor
		let statusText: String = state.serverStatus.rawValue
		switch state.serverStatus {
		case .waiting:
			statusColor = Colors.warningYellow
		case .online:
			statusColor = Colors.affirmativeGreen
		case .offline, .error:
			statusColor = Colors.dangerRed
		}

		view.statusLabel.textColor = statusColor
		view.statusLabel.text = statusText
	}

	public static func ==(lhs: AppItemCellState, rhs: AppItemCellState) -> Bool {
		return lhs.appName == rhs.appName &&
			lhs.appIcon == rhs.appIcon &&
			lhs.dailyActiveUsers == rhs.dailyActiveUsers &&
			lhs.crashes == rhs.crashes &&
			lhs.serverStatus == rhs.serverStatus
	}
}

typealias AppItemCell = HostCell<AppItemCellView, AppItemCellState, EdgeBasedTableItemLayout>
