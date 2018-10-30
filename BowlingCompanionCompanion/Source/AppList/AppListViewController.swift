//
//  AppListViewController.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-10-28.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import FunctionalTableData
import UIKit

class AppListViewController: UIViewController {

	private let refreshControl = UIRefreshControl()
	private let tableView = UITableView()
	private let tableData = FunctionalTableData()

	private var refreshTime: TimeInterval = 0

	private var apps: [App] = []

	override func viewDidLoad() {
		super.viewDidLoad()

		refreshControl.addTarget(self, action: #selector(refreshAppProperties(_:)), for: .valueChanged)
		tableView.addSubview(refreshControl)

		tableView.backgroundColor = Colors.background

		tableView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(tableView)
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			])

		tableData.tableView = tableView
		title = "Bowling Companion Companion"
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		loadApps()
	}

	private func render() {
		tableData.renderAndDiff(AppListBuilder.sections(apps: apps, actionable: self))
	}

	private func loadApps() {
		guard let url = Bundle.main.url(forResource: "Apps", withExtension: "plist") else {
			fatalError("Failed to load Apps.plist")
		}

		let appData = try! Data(contentsOf: url)
		let decoder = PropertyListDecoder()
		apps = try! decoder.decode([App].self, from: appData)
		render()

		refreshAppProperties()
	}

	private func appFinishedStatusQuery() {
		if apps.allSatisfy({ $0.transferServer.lastStatusCheck > refreshTime }) {
			refreshControl.endRefreshing()
			render()
		}
	}

	@objc private func refreshAppProperties(_ sender: AnyObject? = nil) {
		refreshTime = Date().timeIntervalSince1970
		apps.forEach {
			$0.transferServer.queryStatus { [weak self] in
				self?.appFinishedStatusQuery()
			}
		}
	}
}

extension AppListViewController: AppListActionable {
	func viewApp(app: App) {
		let appDetailsViewController = AppDetailsViewController(app: app)
		self.navigationController?.show(appDetailsViewController, sender: self)
	}
}
