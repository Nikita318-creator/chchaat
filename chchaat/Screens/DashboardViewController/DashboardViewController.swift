//
//  DashboardViewController.swift
//  chchaat
//
//

import UIKit
import SnapKit

// MARK: - DashboardViewController (AI Streams Screen)
final class DashboardViewController: UIViewController {

    private let viewModel = HomeViewModel()
    private var expandedSections: Set<Int> = []
    private var dismissKeyboardGesture: UITapGestureRecognizer?

    private var threadCharacters: [AICharacter] {
        return viewModel.threadCharacters
    }

    // Захардкоженные базовые лайки для постов (по ID треда)
    private let basePostLikes: [String: Int] = [
        "t1": 142, "t2": 98, "t3": 215, "t4": 184, "t5": 305,
        "t6": 120, "t7": 167, "t8": 289, "t9": 145, "t10": 192,
        "t11": 210, "t12": 175, "t13": 134, "t14": 160, "t15": 240
    ]

    // Захардкоженные базовые лайки для реплаев (по ID реплая)
    private let baseReplyLikes: [String: Int] = [
        "r1": 12, "r2": 24, "r3": 8, "r4": 19, "r5": 31,
        "r6": 15, "r7": 42, "r8": 7, "r9": 22, "r10": 11
    ]

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        tv.register(ThreadPostCell.self, forCellReuseIdentifier: ThreadPostCell.identifier)
        tv.register(ThreadReplyCell.self, forCellReuseIdentifier: ThreadReplyCell.identifier)
        tv.register(ThreadInputCell.self, forCellReuseIdentifier: ThreadInputCell.identifier)
        tv.showsVerticalScrollIndicator = false
        tv.keyboardDismissMode = .onDrag
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        setupNavigationBar()
        setupUI()
        setupKeyboardObservers()
        setupTapGesture()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupNavigationBar() {
        navigationItem.title = "AI Streams"
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
            let userComments = InteractionManager.shared.getUserComments(forThreadId: thread.id)
            // 1 (пост) + реплаи ИИ + кастомные комменты юзера + 1 (поле ввода)
            return 1 + thread.replies.count + userComments.count + 1
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let character = threadCharacters[indexPath.section]
        guard let thread = character.thread else { return UITableViewCell() }

        let userComments = InteractionManager.shared.getUserComments(forThreadId: thread.id)
        let repliesCount = thread.replies.count

        if indexPath.row == 0 {
            // Главный пост треда
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ThreadPostCell.identifier, for: indexPath) as? ThreadPostCell else {
                return UITableViewCell()
            }
            let isExpanded = expandedSections.contains(indexPath.section)
            let baseLikes = basePostLikes[thread.id] ?? 50
            cell.configure(character: character, isExpanded: isExpanded, baseLikes: baseLikes)
            
            cell.onLikeTapped = { [weak self] in
                InteractionManager.shared.toggleLike(id: thread.id)
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            return cell
            
        } else if indexPath.row <= repliesCount {
            // Реплики других ИИ
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ThreadReplyCell.identifier, for: indexPath) as? ThreadReplyCell else {
                return UITableViewCell()
            }
            let reply = thread.replies[indexPath.row - 1]
            let baseLikes = baseReplyLikes[reply.id] ?? 5
            cell.configure(with: reply, baseLikes: baseLikes)
            
            cell.onLikeTapped = { [weak self] in
                InteractionManager.shared.toggleLike(id: reply.id)
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            return cell
            
        } else if indexPath.row <= repliesCount + userComments.count {
            // Комментарии пользователя
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ThreadReplyCell.identifier, for: indexPath) as? ThreadReplyCell else {
                return UITableViewCell()
            }
            let userReply = userComments[indexPath.row - 1 - repliesCount]
            cell.configure(with: userReply, baseLikes: 1) // Свои комменты стартуют с 1 лайка
            
            cell.onLikeTapped = { [weak self] in
                InteractionManager.shared.toggleLike(id: userReply.id)
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            return cell
            
        } else {
            // Инпут поле ввода в самом низу развернутой ветки
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ThreadInputCell.identifier, for: indexPath) as? ThreadInputCell else {
                return UITableViewCell()
            }
            cell.onSendTapped = { [weak self] text in
                guard let self = self else { return }
                
                // 1. Сохраняем коммент
                InteractionManager.shared.addUserComment(toThreadId: thread.id, content: text)
                
                // 2. Прячем клавиатуру при отправке
                self.view.endEditing(true)
                
                // 3. Перезагружаем секцию
                self.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .bottom)
                
                // 4. Подскролливаем к только что добавленной ячейке
//                let userCommentsCount = InteractionManager.shared.getUserComments(forThreadId: thread.id).count
//                let newCommentRowIndex = thread.replies.count + userCommentsCount
//                let newCommentIndexPath = IndexPath(row: newCommentRowIndex, section: indexPath.section)
//                
//                self.tableView.scrollToRow(at: newCommentIndexPath, at: .bottom, animated: true)
            }
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

// MARK: - Keyboard & Gesture Setup
extension DashboardViewController: UIGestureRecognizerDelegate {

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapToDismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        self.dismissKeyboardGesture = tapGesture
    }

    // Разрешаем жест только если тап пришелся на пустое место (вне интерактивных элементов ячеек)
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view is UIControl || view is UITextField {
            return false
        }
        return true
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardNotification(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardNotification(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func didTapToDismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func handleKeyboardNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }

        let isShowing = notification.name == UIResponder.keyboardWillShowNotification

        if isShowing, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let bottomInset = keyboardFrame.height - view.safeAreaInsets.bottom
            tableView.contentInset.bottom = bottomInset
            tableView.verticalScrollIndicatorInsets.bottom = bottomInset
        } else {
            tableView.contentInset.bottom = 0
            tableView.verticalScrollIndicatorInsets.bottom = 0
        }

        let options = UIView.AnimationOptions(rawValue: curveValue << 16)
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.view.layoutIfNeeded()
        }
    }
}
