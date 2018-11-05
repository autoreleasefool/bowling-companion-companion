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

	private var apps: [App] = []

	private(set) var expectedRequests = 0
	private(set) var completedRequests = 0

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

	private func serviceQueryFinished() {
		completedRequests += 1
		if completedRequests == expectedRequests {
			refreshControl.endRefreshing()
			render()
		}
	}

	@objc private func refreshAppProperties(_ sender: AnyObject? = nil) {
		completedRequests = 0
		expectedRequests = apps.reduce(0, { count, app in
			app.expectedRequests
		})

		apps.forEach { app in
			app.services.forEach { service in
				service.query(delegate: self) { [weak self] in
					self?.serviceQueryFinished()
				}
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
