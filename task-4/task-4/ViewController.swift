//
//  ViewController.swift
//  task-4
//
//  Created by Ахмеров Дмитрий Николаевич on 12.07.2023.
//

import UIKit

final class ViewController: UIViewController {

	private struct Cell {
		let title: String
		var isCheckmark: Bool = false
	}

	private static let cellID = "cellID"

	private var cellsData: [Cell] = Array(0...Int.random(in: 30...100)).map { Cell(title: "\($0)") }

	private lazy var tableView: UITableView = {
		let tableView = UITableView(frame: view.frame, style: .insetGrouped)
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellID)
		tableView.dataSource = dataSource
		tableView.delegate = self
		return tableView
	}()

	private var dataSource: UITableViewDiffableDataSource<Int, String>?

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		view.addSubview(tableView)

		title = "Task 4"
		navigationItem.rightBarButtonItem = .init(title: "Shuffle",
												  style: .done,
												  target: self,
												  action: #selector(userDidTapShuffleButton))

		setupDataSource()
		apply()
	}
}

// MARK: - Private

private extension ViewController {

	@objc func userDidTapShuffleButton() {
		cellsData.shuffle()
		apply()
	}

	func setupDataSource() {
		dataSource = UITableViewDiffableDataSource(tableView: tableView) { [unowned self] tableView, indexPath, itemIdentifier in
			let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellID, for: indexPath)
			cell.accessoryType = self.cellsData[indexPath.row].isCheckmark ? .checkmark : .none

			var content = cell.defaultContentConfiguration()
			content.text = "\(self.cellsData[indexPath.row].title)"
			cell.contentConfiguration = content

			return cell
		}
	}

	func apply() {
		var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
		snapshot.appendSections([.zero])
		snapshot.appendItems(cellsData.map { $0.title }, toSection: .zero)
		dataSource?.apply(snapshot, animatingDifferences: true)
	}
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let selectedCell = tableView.cellForRow(at: indexPath) else { return }
		tableView.deselectRow(at: indexPath, animated: true)
		cellsData[indexPath.row].isCheckmark.toggle()

		if cellsData[indexPath.row].isCheckmark {
			selectedCell.accessoryType = .checkmark

			let selectionData = cellsData[indexPath.row]
			cellsData.remove(at: indexPath.row)
			cellsData.insert(selectionData, at: .zero)

			apply()
		} else {
			selectedCell.accessoryType = .none
		}
	}
}
