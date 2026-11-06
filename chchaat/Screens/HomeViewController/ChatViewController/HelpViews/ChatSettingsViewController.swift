//
//  ChatSettingsViewController.swift
//  chchaat
//

import UIKit
import SnapKit


// MARK: - Chat Settings View Controller Protocol
protocol ChatSettingsDelegate: AnyObject {
    func didRequestImagePicker()
}

// MARK: - Chat Settings View Controller (Popup)
final class ChatSettingsViewController: UIViewController {
    weak var delegate: ChatSettingsDelegate?
    private let characterId: String
    
    private let audioContainerView = UIView()
    private let audioTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Audio Messages"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = AppColors.textPrimary
        return label
    }()
    
    private let toggleSwitch: UISwitch = {
        let switcher = UISwitch()
        switcher.onTintColor = AppColors.tint
        return switcher
    }()
    
    private let backgroundButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Chat Background...", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(AppColors.tint, for: .normal)
        button.setImage(UIImage(systemName: "photo.badge.plus"), for: .normal)
        button.tintColor = AppColors.tint
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        return button
    }()
    
    private let kAudioMessagesKey = "audioMessagesEnabled"

    init(characterId: String) {
        self.characterId = characterId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        loadState()
    }

    private func setupUI() {
        let hasAudio = !BaseManager.shared.audioKey.isEmpty
        audioContainerView.isHidden = !hasAudio

        audioContainerView.addSubview(audioTitleLabel)
        audioContainerView.addSubview(toggleSwitch)

        audioTitleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        toggleSwitch.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
        }

        let stack = UIStackView(arrangedSubviews: [audioContainerView, backgroundButton])
        audioContainerView.snp.makeConstraints { $0.height.equalTo(30) }
        
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        stack.distribution = .fillEqually

        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }

        toggleSwitch.addTarget(self, action: #selector(toggleChanged(_:)), for: .valueChanged)
        backgroundButton.addTarget(self, action: #selector(didTapBackgroundSettings), for: .touchUpInside)
    }

    private func loadState() {
        let isEnabled = UserDefaults.standard.bool(forKey: kAudioMessagesKey)
        toggleSwitch.isOn = isEnabled
    }

    @objc private func toggleChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: kAudioMessagesKey)
    }
    
    @objc private func didTapBackgroundSettings() {
        let alert = UIAlertController(title: "Chat Background", message: "Select your preferred background style", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Default (Gradient)", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            UserDefaults.standard.set("gradient", forKey: "chatBackgroundType_\(self.characterId)")
            self.notifyBackgroundChange()
        }))
        
        alert.addAction(UIAlertAction(title: "Character Avatar", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            UserDefaults.standard.set("avatar", forKey: "chatBackgroundType_\(self.characterId)")
            self.notifyBackgroundChange()
        }))
        
        alert.addAction(UIAlertAction(title: "Upload from Gallery", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true) {
                self?.delegate?.didRequestImagePicker()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = backgroundButton
            popover.sourceRect = backgroundButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    private func notifyBackgroundChange() {
        NotificationCenter.default.post(name: .init("ChatBackgroundDidChangeNotification"), object: nil)
        dismiss(animated: true)
    }
}
