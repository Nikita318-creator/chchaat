//
//  ChatViewController.swift
//  chchaat
//

import UIKit
import SnapKit

final class ChatViewController: UIViewController {
    private let viewModel: ChatViewModel
    private let gradientLayer = CAGradientLayer()
    private var didInitialScroll = false
    private let speechService = SpeechRecognitionService()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.dataSource = self
        tv.delegate = self
        tv.register(ChatMessageCell.self, forCellReuseIdentifier: ChatMessageCell.reuseId)
        tv.register(ChatAudioMessageCell.self, forCellReuseIdentifier: ChatAudioMessageCell.reuseId)
        tv.keyboardDismissMode = .interactive
        tv.allowsSelection = false
        return tv
    }()

    private let inputBar = ChatInputBar()

    // Индикатор печати над инпут-баром
    private let typingFooterView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    private let typingDots = TypingDotsView()
    private let typingLabel: UILabel = {
        let label = UILabel()
        label.text = "typing..."
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = AppColors.textSecondary
        return label
    }()

    // Статус в навбаре (Online / typing...)
    private let statusLabel = UILabel()

    init(character: AICharacter) {
        self.viewModel = ChatViewModel(character: character)
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true   // прячем TabBar
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tap)

        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        if !didInitialScroll, tableView.bounds.height > 0 {
            didInitialScroll = true
            scrollToBottom(animated: false)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAllAudioInVisibleCells()
    }

    private func stopAllAudioInVisibleCells() {
        for cell in tableView.visibleCells {
            if let audioCell = cell as? ChatAudioMessageCell {
                audioCell.stopAudio()
            }
        }
    }
    
    @objc private func dismissKeyboard() { view.endEditing(true) }

    @objc private func keyboardWillShow() {
        DispatchQueue.main.async { [weak self] in self?.scrollToBottom(animated: true) }
    }

    // MARK: - UI

    private func setupUI() {
        gradientLayer.colors = AppGradients.chatBackground(for: view.bounds).colors
        view.layer.insertSublayer(gradientLayer, at: 0)

        setupNavigationBar()

        view.addSubview(tableView)
        view.addSubview(typingFooterView)
        view.addSubview(inputBar)
        inputBar.delegate = self

        let typingStack = UIStackView(arrangedSubviews: [typingDots, typingLabel])
        typingStack.axis = .horizontal
        typingStack.spacing = 6
        typingStack.alignment = .center
        typingFooterView.addSubview(typingStack)
        typingStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }

        // Клавиатуру ведёт keyboardLayoutGuide (iOS 15+)
        inputBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }

        typingFooterView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(inputBar.snp.top)
            make.height.equalTo(20)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(typingFooterView.snp.top)
        }
    }

    private func setupNavigationBar() {
        let titleView = UIView()

        let avatarImageView = UIImageView()
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 18
        avatarImageView.clipsToBounds = true
        avatarImageView.image = UIImage(named: viewModel.character.imageName)
            ?? UIImage(systemName: "person.circle.fill")
        avatarImageView.tintColor = AppColors.tint

        let nameLabel = UILabel()
        nameLabel.text = viewModel.character.name
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        nameLabel.textColor = AppColors.textPrimary

        let statusDot = UIView()
        statusDot.backgroundColor = AppColors.onlineIndicator
        statusDot.layer.cornerRadius = 4
        statusDot.snp.makeConstraints { $0.width.height.equalTo(8) }

        statusLabel.text = "Online"
        statusLabel.font = .systemFont(ofSize: 12, weight: .regular)
        statusLabel.textColor = AppColors.textSecondary

        let statusStack = UIStackView(arrangedSubviews: [statusDot, statusLabel])
        statusStack.spacing = 6
        statusStack.alignment = .center

        let textStack = UIStackView(arrangedSubviews: [nameLabel, statusStack])
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.spacing = 2

        titleView.addSubview(avatarImageView)
        titleView.addSubview(textStack)

        avatarImageView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.height.equalTo(36)
        }
        textStack.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(10)
            make.trailing.centerY.equalToSuperview()
        }
        titleView.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(40)
        }

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleView)
        navigationItem.leftItemsSupplementBackButton = true   // оставляем кнопку "назад"

        // Кнопка настроек в правом верхнем углу (три точки вертикально)
        let settingsButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(didTapSettings)
        )
        settingsButton.tintColor = AppColors.tint
        navigationItem.rightBarButtonItem = settingsButton

        navigationController?.navigationBar.tintColor = AppColors.tint
    }

    @objc private func didTapSettings() {
        let settingsVC = ChatSettingsViewController()
        settingsVC.modalPresentationStyle = .popover
        settingsVC.preferredContentSize = CGSize(width: 230, height: 56)

        if let popover = settingsVC.popoverPresentationController {
            popover.barButtonItem = navigationItem.rightBarButtonItem
            popover.permittedArrowDirections = [.up, .down]
            popover.delegate = self
        }

        present(settingsVC, animated: true)
    }

    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] in
            guard let self else { return }
            let isTyping = self.viewModel.isTyping
            self.typingFooterView.isHidden = !isTyping
            self.statusLabel.text = isTyping ? "typing..." : "Online"
            isTyping ? self.typingDots.start() : self.typingDots.stop()
        }

        viewModel.onMessageAppended = { [weak self] index in
            guard let self else { return }
            self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            self.scrollToBottom(animated: true)
        }
    }

    private func scrollToBottom(animated: Bool) {
        let count = viewModel.messages.count
        guard count > 0 else { return }
        tableView.scrollToRow(at: IndexPath(row: count - 1, section: 0), at: .bottom, animated: animated)
    }
}

// MARK: - UIPopoverPresentationControllerDelegate
extension ChatViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: - UITableViewDataSource & Delegate
extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = viewModel.messages[indexPath.row]
        
        if message.isAudioMessage {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ChatAudioMessageCell.reuseId, for: indexPath
            ) as? ChatAudioMessageCell else { return UITableViewCell() }
            cell.configure(with: message)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ChatMessageCell.reuseId, for: indexPath
            ) as? ChatMessageCell else { return UITableViewCell() }
            cell.configure(with: message)
            return cell
        }
    }

    // Подход 1: Контекстное меню по долгому тапу
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let message = viewModel.messages[indexPath.row]

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let copyAction = UIAction(
                title: "Copy",
                image: UIImage(systemName: "doc.on.doc")
            ) { _ in
                UIPasteboard.general.string = message.text
                
                // Легкий тактильный отклик при копировании
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            }

            return UIMenu(title: "", children: [copyAction])
        }
    }
}

// MARK: - ChatInputBarDelegate
extension ChatViewController: ChatInputBarDelegate {
    func chatInputBarDidTapSend(_ inputBar: ChatInputBar, text: String, language: String?) {
        viewModel.sendMessage(text: text, language: language)
    }

    func chatInputBarDidStartRecording(_ inputBar: ChatInputBar) {
        speechService.requestAuthorization { [weak self] authorized in
            guard let self = self else { return }
            if authorized {
                self.speechService.onTranscription = { [weak self] transcribedText in
                    DispatchQueue.main.async {
                        self?.inputBar.setText(transcribedText)
                    }
                }

                // Берем текущий язык клавиатуры или системы
                let currentLanguage = inputBar.currentLanguage ?? Locale.preferredLanguages.first

                self.speechService.startRecording(languageCode: currentLanguage) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            inputBar.setRecording(true)
                        case .failure(let error):
                            print("Ошибка запуска записи: \(error.localizedDescription)")
                            inputBar.setRecording(false)
                        }
                    }
                }
            }
        }
    }

    func chatInputBarDidTapStopRecording(_ inputBar: ChatInputBar) {
        speechService.stopRecording()
        inputBar.setRecording(false)
    }
}

// MARK: - Chat Settings View Controller (Popup)
final class ChatSettingsViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Audio Messages"
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = AppColors.textPrimary
        return label
    }()
    
    private let toggleSwitch: UISwitch = {
        let switcher = UISwitch()
        switcher.onTintColor = AppColors.tint
        return switcher
    }()
    
    private let kAudioMessagesKey = "audioMessagesEnabled"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        loadState()
    }

    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [titleLabel, toggleSwitch])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        stack.distribution = .equalSpacing

        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }

        toggleSwitch.addTarget(self, action: #selector(toggleChanged(_:)), for: .valueChanged)
    }

    private func loadStyle() {
        // Дополнительные стилистические настройки при необходимости
    }

    private func loadState() {
        let isEnabled = UserDefaults.standard.bool(forKey: kAudioMessagesKey)
        toggleSwitch.isOn = isEnabled
    }

    @objc private func toggleChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: kAudioMessagesKey)
    }
}
