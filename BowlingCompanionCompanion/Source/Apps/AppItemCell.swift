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
	private let app: App

	init(app: App) {
		self.app = app
	}

	public static func updateView(_ view: AppItemCellView, state: AppItemCellState?) {
		guard let state = state else {
			view.prepareForReuse()
			return
		}

		view.imageView.image = state.app.icon
		view.titleLabel.text = state.app.name
		view.dauLabel.text = "\(state.app.dailyActiveUsers) DAU"
		view.crashesLabel.text = "\(state.app.crashes) crashes"

		let statusColor: UIColor
		let statusText: String = state.app.serverStatus.rawValue
		switch state.app.serverStatus {
		case .loading:
			statusColor = Colors.warningYellow
		case .online:
			statusColor = Colors.affirmativeGreen
		case .offline:
			statusColor = Colors.dangerRed
		}

		view.statusLabel.textColor = statusColor
		view.statusLabel.text = statusText
	}

	public static func ==(lhs: AppItemCellState, rhs: AppItemCellState) -> Bool {
		return lhs.app.name == rhs.app.name &&
			lhs.app.iconName == rhs.app.iconName &&
			lhs.app.dailyActiveUsers == rhs.app.dailyActiveUsers &&
			lhs.app.crashes == rhs.app.crashes &&
			lhs.app.serverStatus == rhs.app.serverStatus
	}
}

typealias AppItemCell = HostCell<AppItemCellView, AppItemCellState, EdgeBasedTableItemLayout>