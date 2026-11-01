//
//  ChatMessageCell.swift
//  chchaat
//

import UIKit
import SnapKit

final class ChatMessageCell: UITableViewCell {
    static let reuseId = "ChatMessageCell"

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()

    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return view
    }()

    private let messageTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 15, weight: .regular)
        tv.textColor = AppColors.textPrimary
        tv.backgroundColor = .clear
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.textContainerInset = .zero
        tv.textContainer.lineFragmentPadding = 0
        return tv
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = AppColors.textMuted
        return label
    }()

    private var leadingConstraint: Constraint?
    private var trailingConstraint: Constraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupLayout() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageTextView)
        bubbleView.addSubview(timeLabel)

        bubbleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().inset(6)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.75)
            leadingConstraint = make.leading.equalToSuperview().offset(16).constraint
            trailingConstraint = make.trailing.equalToSuperview().inset(16).constraint
        }

        messageTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().inset(14)
        }

        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(messageTextView.snp.bottom).offset(4)
            make.trailing.equalTo(messageTextView.snp.trailing)
            make.bottom.equalToSuperview().inset(8)
        }
    }

    func configure(with message: MessageModel) {
        messageTextView.text = message.text
        timeLabel.text = Self.timeFormatter.string(from: message.timestamp)

        if message.isFromUser {
            // юзер — справа
            bubbleView.backgroundColor = AppColors.bubbleOutgoing
            bubbleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
            leadingConstraint?.deactivate()
            trailingConstraint?.activate()
        } else {
            // ИИ — слева
            bubbleView.backgroundColor = AppColors.bubbleIncoming
            bubbleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            trailingConstraint?.deactivate()
            leadingConstraint?.activate()
        }
    }
}
