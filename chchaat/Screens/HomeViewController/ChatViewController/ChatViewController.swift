//
//  ChatViewController.swift
//  chchaat
//

import UIKit
import SnapKit
import PhotosUI
import AVKit

final class ChatViewController: UIViewController {
    private let viewModel: ChatViewModel
    private let gradientLayer = CAGradientLayer()
    private let backgroundImageView = UIImageView()
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
        tv.register(ChatPhotoMessageCell.self, forCellReuseIdentifier: ChatPhotoMessageCell.reuseId)
        tv.register(ChatVideoMessageCell.self, forCellReuseIdentifier: ChatVideoMessageCell.reuseId)
        tv.keyboardDismissMode = .interactive
        tv.allowsSelection = false
        return tv
    }()

    private let inputBar = ChatInputBar()

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

    private let statusLabel = UILabel()

    // UI элементы промптов
    private let promptSuggestionsContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.isHidden = true
        return stack
    }()
    
    private lazy var photoPromptButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Send me a photo", for: .normal)
        btn.setTitleColor(AppColors.tint, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        btn.backgroundColor = AppColors.surface
        btn.layer.cornerRadius = 14
        btn.layer.borderWidth = 1
        btn.layer.borderColor = AppColors.separator.cgColor
        btn.addTarget(self, action: #selector(didTapPhotoPrompt), for: .touchUpInside)
        return btn
    }()
    
    private lazy var videoPromptButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Send me a video", for: .normal)
        btn.setTitleColor(AppColors.tint, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        btn.backgroundColor = AppColors.surface
        btn.layer.cornerRadius = 14
        btn.layer.borderWidth = 1
        btn.layer.borderColor = AppColors.separator.cgColor
        btn.addTarget(self, action: #selector(didTapVideoPrompt), for: .touchUpInside)
        return btn
    }()
    
    init(character: AICharacter) {
        self.viewModel = ChatViewModel(character: character)
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        applyChatBackground()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tap)

        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(chatBackgroundDidChange),
            name: .init("ChatBackgroundDidChangeNotification"), object: nil
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        backgroundImageView.frame = view.bounds
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
    
    @objc private func chatBackgroundDidChange() {
        applyChatBackground()
    }

    // MARK: - Background Management & FileManager Helpers

    private func getCustomImageURL(for characterId: String) -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documents.appendingPathComponent("chat_background_\(characterId).jpg")
    }

    private func saveCustomImage(_ image: UIImage, for characterId: String) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let url = getCustomImageURL(for: characterId)
        try? data.write(to: url)
    }

    private func loadCustomImage(for characterId: String) -> UIImage? {
        let url = getCustomImageURL(for: characterId)
        if let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }

    private func applyChatBackground() {
        let characterId = viewModel.character.id
        let typeKey = "chatBackgroundType_\(characterId)"
        
        let type = UserDefaults.standard.string(forKey: typeKey) ?? (BaseManager.shared.audioKey.isEmpty ? "gradient" : "avatar")

        backgroundImageView.isHidden = true
        gradientLayer.isHidden = true

        switch type {
        case "gradient":
            gradientLayer.isHidden = false
            gradientLayer.colors = AppGradients.chatBackground(for: view.bounds).colors
        case "avatar":
            backgroundImageView.isHidden = false
            backgroundImageView.image = UIImage(named: viewModel.character.imageName) ?? UIImage(systemName: "person.circle.fill")
            backgroundImageView.contentMode = .scaleAspectFill
        case "custom":
            backgroundImageView.isHidden = false
            if let image = loadCustomImage(for: characterId) {
                backgroundImageView.image = image
            } else {
                backgroundImageView.image = UIImage(named: viewModel.character.imageName)
            }
            backgroundImageView.contentMode = .scaleAspectFill
        default:
            gradientLayer.isHidden = false
            gradientLayer.colors = AppGradients.chatBackground(for: view.bounds).colors
        }
    }

    // MARK: - UI

    private func setupUI() {
        gradientLayer.colors = AppGradients.chatBackground(for: view.bounds).colors
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        backgroundImageView.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImageView, at: 1)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        setupNavigationBar()

        view.addSubview(tableView)
        view.addSubview(typingFooterView)
        view.addSubview(inputBar)
        inputBar.delegate = self
        
        // Добавление контейнера подсказок над инпут баром
        view.addSubview(promptSuggestionsContainer)
        promptSuggestionsContainer.addArrangedSubview(photoPromptButton)
        promptSuggestionsContainer.addArrangedSubview(videoPromptButton)
        
        let typingStack = UIStackView(arrangedSubviews: [typingDots, typingLabel])
        typingStack.axis = .horizontal
        typingStack.spacing = 6
        typingStack.alignment = .center
        typingFooterView.addSubview(typingStack)
        typingStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }

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
        
        
        if !BaseManager.shared.imagesPath.isEmpty {
            promptSuggestionsContainer.isHidden = false
            promptSuggestionsContainer.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                make.bottom.equalTo(inputBar.snp.top).offset(-8)
                make.height.equalTo(36)
            }
            typingFooterView.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(promptSuggestionsContainer.snp.top)
                make.height.equalTo(20)
            }
        } else {
            typingFooterView.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(inputBar.snp.top)
                make.height.equalTo(20)
            }
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
        navigationItem.leftItemsSupplementBackButton = true

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
        let settingsVC = ChatSettingsViewController(characterId: viewModel.character.id)
        settingsVC.modalPresentationStyle = .popover
        
        let hasAudio = !BaseManager.shared.audioKey.isEmpty
        let height: CGFloat = hasAudio ? 120 : 70
        settingsVC.preferredContentSize = CGSize(width: 260, height: height)
        settingsVC.delegate = self

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
            self.tableView.reloadData()
            self.scrollToBottom(animated: true)
        }
    }

    private func scrollToBottom(animated: Bool) {
        let count = viewModel.messages.count
        guard count > 0 else { return }
        tableView.scrollToRow(at: IndexPath(row: count - 1, section: 0), at: .bottom, animated: animated)
    }
    
    @objc private func didTapPhotoPrompt() {
        viewModel.sendMediaMessage(text: "Send a photo", mediaType: "photo", isVideo: false)
    }
    
    @objc private func didTapVideoPrompt() {
        viewModel.sendMediaMessage(text: "Send a video", mediaType: "video", isVideo: true)
    }
}

// MARK: - ChatSettingsDelegate
extension ChatViewController: ChatSettingsDelegate {
    func didRequestImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension ChatViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let self = self, let image = image as? UIImage else { return }
            let characterId = self.viewModel.character.id
            
            // Сохраняем картинку через FileManager в документы приложения
            self.saveCustomImage(image, for: characterId)
            UserDefaults.standard.set("custom", forKey: "chatBackgroundType_\(characterId)")
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .init("ChatBackgroundDidChangeNotification"), object: nil)
            }
        }
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
        
        if message.mediaType == "photo" {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ChatPhotoMessageCell.reuseId, for: indexPath
            ) as? ChatPhotoMessageCell else { return UITableViewCell() }
            cell.configure(with: message)
            
            // Обработка тапа по фото для открытия превью
            cell.isUserInteractionEnabled = true
            let tap = PhotoTapGesture(target: self, action: #selector(didTapPhotoCell(_:)), message: message)
            cell.contentView.gestureRecognizers?.forEach { cell.contentView.removeGestureRecognizer($0) }
            cell.contentView.addGestureRecognizer(tap)
            
            return cell
        } else if message.mediaType == "video" {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ChatVideoMessageCell.reuseId, for: indexPath
            ) as? ChatVideoMessageCell else { return UITableViewCell() }
            cell.configure(with: message)
            
            // Обработка тапа по видео для запуска AVPlayerViewController
            cell.isUserInteractionEnabled = true
            let tap = VideoTapGesture(target: self, action: #selector(didTapVideoCell(_:)), message: message)
            cell.contentView.gestureRecognizers?.forEach { cell.contentView.removeGestureRecognizer($0) }
            cell.contentView.addGestureRecognizer(tap)
            
            return cell
        } else if message.isAudioMessage {
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
    
    @objc private func didTapPhotoCell(_ sender: PhotoTapGesture) {
        guard let path = sender.message.mediaLocalPath, let image = UIImage(contentsOfFile: path) else { return }
        let previewVC = PhotoPreviewViewController(image: image)
        present(previewVC, animated: false)
    }
    
    @objc private func didTapVideoCell(_ sender: VideoTapGesture) {
        guard let path = sender.message.mediaLocalPath else { return }
        let url = URL(fileURLWithPath: path)
        let player = AVPlayer(url: url)
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { [weak player] _ in
            player?.seek(to: .zero)
            player?.play()
        }
        
        present(playerVC, animated: true) {
            player.play()
        }
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let message = viewModel.messages[indexPath.row]

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let copyAction = UIAction(
                title: "Copy",
                image: UIImage(systemName: "doc.on.doc")
            ) { _ in
                UIPasteboard.general.string = message.text
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
                let currentLanguage = inputBar.currentLanguage ?? Locale.preferredLanguages.first
                self.speechService.startRecording(languageCode: currentLanguage) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            inputBar.setRecording(true)
                        case .failure(let error):
                            print("Failed to start recording: \(error.localizedDescription)")
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
