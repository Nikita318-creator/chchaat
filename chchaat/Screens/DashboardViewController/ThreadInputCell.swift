//
//  ThreadInputCell.swift
//  chchaat
//

import UIKit
import SnapKit

final class ThreadInputCell: UITableViewCell {
    static let identifier = "ThreadInputCell"

    var onSendTapped: ((String) -> Void)?

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.surface
        view.layer.cornerRadius = 16
        return view
    }()

    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(
            string: "Share your thoughts with AI...",
            attributes: [.foregroundColor: AppColors.textMuted]
        )
        tf.textColor = AppColors.textPrimary
        tf.font = .systemFont(ofSize: 14, weight: .regular)
        return tf
    }()

    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
        button.setImage(UIImage(systemName: "arrow.up.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = AppColors.tint
        button.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.addSubview(textField)
        containerView.addSubview(sendButton)

        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }

        textField.snp.makeConstraints { make in
            make.leading.equalTo(containerView).offset(16)
            make.trailing.equalTo(sendButton.snp.leading).offset(-8)
            make.centerY.equalTo(containerView)
        }

        sendButton.snp.makeConstraints { make in
            make.trailing.equalTo(containerView).offset(-12)
            make.centerY.equalTo(containerView)
            make.size.equalTo(32)
        }
    }

    @objc private func didTapSend() {
        guard let text = textField.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        onSendTapped?(text)
        textField.text = nil
        textField.resignFirstResponder()
    }
}
