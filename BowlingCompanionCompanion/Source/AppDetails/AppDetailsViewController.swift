//
//  AppDetailsViewController.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-10-30.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

class AppDetailsViewController: UIViewController {
	private let app: App

	private let refreshControl = UIRefreshControl()
	private let tableView = UITableView()
	private let tableData = FunctionalTableData()

	private(set) var expectedRequests = 0
	private(set) var completedRequests = 0

	init(app: App) {
		self.app = app
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		refreshControl.addTarget(self, action: #selector(refreshAppDetails(_:)), for: .valueChanged)
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
		title = app.name
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		refreshAppDetails()
	}

	private func render() {
		tableData.renderAndDiff(AppDetailsBuilder.sections(app: app))
	}

	private func serviceQueryFinished() {
		completedRequests += 1
		if completedRequests == expectedRequests {
			refreshControl.endRefreshing()
			render()
		}
	}

	@objc private func refreshAppDetails(_ sender: AnyObject? = nil) {
		completedRequests = 0
		expectedRequests = app.expectedRequests

		app.services.forEach { service in
			service.query(delegate: self) { [weak self] in
				self?.serviceQueryFinished()
			}
		}
	}
}
