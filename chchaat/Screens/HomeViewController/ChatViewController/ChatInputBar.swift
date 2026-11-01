//
//  ChatInputBar.swift
//  chchaat
//

import UIKit
import SnapKit

protocol ChatInputBarDelegate: AnyObject {
    func chatInputBarDidTapSend(_ inputBar: ChatInputBar, text: String, language: String?)
}

final class ChatInputBar: UIView {
    weak var delegate: ChatInputBarDelegate?

    private let minHeight: CGFloat = 44
    private let maxHeight: CGFloat = 120
    private var textViewHeightConstraint: Constraint?

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

    private lazy var sendButton: UIButton = {
        let btn = UIButton(type: .system)
        let image = UIImage(
            systemName: "arrow.up.circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .bold)
        )
        btn.setImage(image, for: .normal)
        btn.tintColor = AppColors.textMuted
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        textView.delegate = self
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupLayout() {
        backgroundColor = AppColors.background

        // sendButton — ребёнок бара, а НЕ контейнера (это и был цикл в лейауте)
        addSubview(containerView)
        addSubview(sendButton)
        containerView.addSubview(textView)
        containerView.addSubview(placeholderLabel)

        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalTo(containerView.snp.bottom)
            make.width.height.equalTo(44)
        }

        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(sendButton.snp.leading).offset(-4)
        }

        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            textViewHeightConstraint = make.height.equalTo(minHeight).constraint
        }

        placeholderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(17) // inset 12 + lineFragmentPadding 5
            make.centerY.equalTo(containerView.snp.top).offset(minHeight / 2)
        }
    }

    private func refresh() {
        let trimmed = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        placeholderLabel.isHidden = !textView.text.isEmpty
        sendButton.isEnabled = !trimmed.isEmpty
        sendButton.tintColor = trimmed.isEmpty ? AppColors.textMuted : AppColors.tint

        guard textView.bounds.width > 0 else { return }
        let fitting = textView.sizeThatFits(
            CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude)
        ).height
        let newHeight = min(max(fitting, minHeight), maxHeight)
        textView.isScrollEnabled = fitting > maxHeight

        textViewHeightConstraint?.update(offset: newHeight)
        UIView.animate(withDuration: 0.15) { self.superview?.layoutIfNeeded() }
    }

    @objc private func sendTapped() {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        let language = textView.textInputMode?.primaryLanguage ?? Locale.preferredLanguages.first
        delegate?.chatInputBarDidTapSend(self, text: text, language: language)

        textView.text = ""
        refresh()
    }
}

extension ChatInputBar: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) { refresh() }
}
