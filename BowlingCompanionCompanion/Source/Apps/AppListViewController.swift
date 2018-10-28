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

	private let tableView = UITableView()
	private let tableData = FunctionalTableData()

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.backgroundColor = Colors.listItem

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
		render()
	}

	private func render() {
		tableData.renderAndDiff(AppListBuilder.sections())
	}
}
