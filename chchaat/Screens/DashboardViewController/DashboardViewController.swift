//
//  DashboardViewController.swift
//  chchaat
//
//

import UIKit
import SnapKit

// MARK: - DashboardViewController (Threads Screen)
final class DashboardViewController: UIViewController {

    private let viewModel = HomeViewModel()
    private var expandedSections: Set<Int> = []

    // Вычисляемое свойство, которое подтягивает треды из расширения HomeViewModel
    private var threadCharacters: [AICharacter] {
        return viewModel.threadCharacters
    }

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        tv.register(ThreadPostCell.self, forCellReuseIdentifier: ThreadPostCell.identifier)
        tv.register(ThreadReplyCell.self, forCellReuseIdentifier: ThreadReplyCell.identifier)
        tv.showsVerticalScrollIndicator = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        setupNavigationBar()
        setupUI()
    }

    private func setupNavigationBar() {
        navigationItem.title = "AI Threads" // Исправлено: ставим заголовок навигации, не трогая таббар
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColors.background
        appearance.titleTextAttributes = [.foregroundColor: AppColors.textPrimary]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - UITableView Protocols
extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return threadCharacters.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < threadCharacters.count, let thread = threadCharacters[section].thread else { return 0 }

        if expandedSections.contains(section) {
            return 1 + thread.replies.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let character = threadCharacters[indexPath.section]

        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ThreadPostCell.identifier, for: indexPath) as? ThreadPostCell else {
                return UITableViewCell()
            }
            let isExpanded = expandedSections.contains(indexPath.section)
            cell.configure(character: character, isExpanded: isExpanded)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ThreadReplyCell.identifier, for: indexPath) as? ThreadReplyCell,
                  let thread = character.thread else {
                return UITableViewCell()
            }
            let reply = thread.replies[indexPath.row - 1]
            cell.configure(with: reply)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.row == 0 {
            let section = indexPath.section
            if expandedSections.contains(section) {
                expandedSections.remove(section)
            } else {
                expandedSections.insert(section)
            }

            tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
