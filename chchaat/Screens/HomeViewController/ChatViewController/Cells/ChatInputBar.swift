//
//  ChatInputBar.swift
//  chchaat
//

import UIKit
import SnapKit

protocol ChatInputBarDelegate: AnyObject {
    func chatInputBarDidTapSend(_ inputBar: ChatInputBar, text: String, language: String?)
    func chatInputBarDidStartRecording(_ inputBar: ChatInputBar)
    func chatInputBarDidTapStopRecording(_ inputBar: ChatInputBar)
}

final class ChatInputBar: UIView {
    weak var delegate: ChatInputBarDelegate?

    private let minHeight: CGFloat = 44
    private let maxHeight: CGFloat = 120
    private var textViewHeightConstraint: Constraint?
    private var isRecording = false

    var currentLanguage: String?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.surface
        view.layer.cornerRadius = 22
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColors.separator.cgColor
        return view
    }()

    private let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.textColor = AppColors.textPrimary
        tv.font = .systemFont(ofSize: 15, weight: .regular)
        tv.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        tv.isScrollEnabled = false
        return tv
    }()

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Type a message..."
        label.textColor = AppColors.textMuted
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()

    private lazy var rightButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 16
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        textView.delegate = self
        updateRightButtonAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupLayout() {
        backgroundColor = AppColors.background

        addSubview(containerView)
        addSubview(rightButton)
        containerView.addSubview(textView)
        containerView.addSubview(placeholderLabel)

        rightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalTo(containerView.snp.centerY)
            make.width.height.equalTo(32)
        }

        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(rightButton.snp.leading).offset(-4)
        }

        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            textViewHeightConstraint = make.height.equalTo(minHeight).constraint
        }

        placeholderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(17)
            make.centerY.equalTo(containerView.snp.top).offset(minHeight / 2)
        }
    }

    private func refresh() {
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        if !isRecording {
            updateRightButtonAppearance()
        }

        guard textView.bounds.width > 0 else { return }
        let fitting = textView.sizeThatFits(
            CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude)
        ).height
        let newHeight = min(max(fitting, minHeight), maxHeight)
        textView.isScrollEnabled = fitting > maxHeight

        textViewHeightConstraint?.update(offset: newHeight)
        UIView.animate(withDuration: 0.15) { self.superview?.layoutIfNeeded() }
    }

    private func updateRightButtonAppearance() {
        let trimmed = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)

        if isRecording {
            // Состояние записи: красный круг с иконкой стоп
            let image = UIImage(
                systemName: "stop.fill",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
            )
            rightButton.setImage(image, for: .normal)
            rightButton.tintColor = .white
            rightButton.backgroundColor = .systemRed
        } else if !trimmed.isEmpty {
            // Состояние отправки: классический самолетик (как в Telegram), повернутый под нужным углом
            let image = UIImage(
                systemName: "paperplane.fill",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
            )
            rightButton.setImage(image, for: .normal)
            rightButton.tintColor = .white
            rightButton.backgroundColor = AppColors.tint
        } else {
            // Состояние микрофона (когда текст пуст)
            let image = UIImage(
                systemName: "mic.fill",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
            )
            rightButton.setImage(image, for: .normal)
            rightButton.tintColor = AppColors.textSecondary
            rightButton.backgroundColor = AppColors.surface
        }
    }

    @objc private func rightButtonTapped() {
        if isRecording {
            delegate?.chatInputBarDidTapStopRecording(self)
        } else {
            let trimmed = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty {
                sendTapped()
            } else {
                delegate?.chatInputBarDidStartRecording(self)
            }
        }
    }

    private func sendTapped() {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        let language = textView.textInputMode?.primaryLanguage ?? Locale.preferredLanguages.first
        self.currentLanguage = language
        delegate?.chatInputBarDidTapSend(self, text: text, language: language)

        textView.text = ""
        refresh()
    }

    func setRecording(_ recording: Bool) {
        isRecording = recording
        updateRightButtonAppearance()
    }

    func setText(_ text: String) {
        textView.text = text
        refresh()
    }
}

extension ChatInputBar: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) { refresh() }
}
