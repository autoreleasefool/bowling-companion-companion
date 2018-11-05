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
	fileprivate let secureStatusLabel = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)

		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false

		titleLabel.textColor = Colors.Text.primaryBlack
		titleLabel.font = UIFont(name: titleLabel.font.fontName, size: Metrics.TextSize.title)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false

		dauLabel.textColor = Colors.affirmativeGreen
		dauLabel.font = UIFont(name: dauLabel.font.fontName, size: Metrics.TextSize.body)
		dauLabel.translatesAutoresizingMaskIntoConstraints = false

		crashesLabel.textColor = Colors.dangerRed
		crashesLabel.font = UIFont(name: crashesLabel.font.fontName, size: Metrics.TextSize.body)
		crashesLabel.translatesAutoresizingMaskIntoConstraints = false

		statusLabel.font = UIFont(name: statusLabel.font.fontName, size: Metrics.TextSize.body)
		statusLabel.translatesAutoresizingMaskIntoConstraints = false

		secureStatusLabel.font = UIFont(name: secureStatusLabel.font.fontName, size: Metrics.TextSize.body)
		secureStatusLabel.translatesAutoresizingMaskIntoConstraints = false

		addSubview(imageView)
		addSubview(titleLabel)
		addSubview(dauLabel)
		addSubview(crashesLabel)
		addSubview(statusLabel)
		addSubview(secureStatusLabel)

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

			secureStatusLabel.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor, constant: Metrics.Spacing.large),
			secureStatusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.Spacing.small),
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
	private let serverStatus: TransferService.Status
	private let secureServerStatus: TransferService.Status?

	init(app: App) {
		self.appIcon = app.icon
		self.appName = app.name
		self.dailyActiveUsers = app.mixpanelService.dailyActiveUsers
		self.crashes = 0
		self.serverStatus = app.transferService.status
		self.secureServerStatus = app.secureTransferService?.status
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
		view.statusLabel.textColor = state.serverStatus.color
		view.statusLabel.text = state.serverStatus.rawValue

		if let secureServerStatus = state.secureServerStatus {
			view.secureStatusLabel.textColor = secureServerStatus.color
			view.secureStatusLabel.text = secureServerStatus.rawValue
			view.secureStatusLabel.isHidden = false
		} else {
			view.secureStatusLabel.isHidden = true
		}
	}

	public static func ==(lhs: AppItemCellState, rhs: AppItemCellState) -> Bool {
		return lhs.appName == rhs.appName &&
			lhs.appIcon == rhs.appIcon &&
			lhs.dailyActiveUsers == rhs.dailyActiveUsers &&
			lhs.crashes == rhs.crashes &&
			lhs.serverStatus == rhs.serverStatus &&
			lhs.secureServerStatus == rhs.secureServerStatus
	}
}

fileprivate extension TransferService.Status {
	var color: UIColor {
		switch self {
		case .waiting: return Colors.warningYellow
		case .online: return Colors.affirmativeGreen
		case .offline, .error, .partiallyOnline: return Colors.dangerRed
		}
	}
}

typealias AppItemCell = HostCell<AppItemCellView, AppItemCellState, EdgeBasedTableItemLayout>
