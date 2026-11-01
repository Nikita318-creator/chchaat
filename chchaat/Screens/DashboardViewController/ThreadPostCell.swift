//
//  ThreadPostCell.swift
//  chchaat
//

import UIKit
import SnapKit

// MARK: - Thread Post Header Cell
final class ThreadPostCell: UITableViewCell {
    static let identifier = "ThreadPostCell"

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.surface
        view.layer.cornerRadius = 16
        return view
    }()

    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.backgroundColor = AppColors.surfaceElevated
        return iv
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = AppColors.textPrimary
        return label
    }()

    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = AppColors.textMuted
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = AppColors.textPrimary
        label.numberOfLines = 0
        return label
    }()

    private let repliesCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = AppColors.tint
        return label
    }()

    private let chevronImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.down"))
        iv.tintColor = AppColors.textMuted
        iv.contentMode = .scaleAspectFit
        return iv
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
        containerView.addSubview(avatarImageView)
        containerView.addSubview(authorLabel)
        containerView.addSubview(timestampLabel)
        containerView.addSubview(contentLabel)
        containerView.addSubview(repliesCountLabel)
        containerView.addSubview(chevronImageView)

        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        avatarImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(14)
            make.size.equalTo(40)
        }

        authorLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            make.top.equalTo(avatarImageView).offset(2)
        }

        timestampLabel.snp.makeConstraints { make in
            make.leading.equalTo(authorLabel.snp.trailing).offset(8)
            make.centerY.equalTo(authorLabel)
        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(10)
            make.leading.equalTo(avatarImageView)
            make.trailing.equalToSuperview().offset(-14)
        }

        repliesCountLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(12)
            make.leading.equalTo(contentLabel)
            make.bottom.equalToSuperview().offset(-14)
        }

        chevronImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-14)
            make.centerY.equalTo(repliesCountLabel)
            make.size.equalTo(14)
        }
    }

    func configure(character: AICharacter, isExpanded: Bool) {
        avatarImageView.image = UIImage(named: character.imageName)
        authorLabel.text = character.name
        
        if let thread = character.thread {
            timestampLabel.text = thread.timestamp
            contentLabel.text = thread.content
            repliesCountLabel.text = "💬 \(thread.replies.count) AI Replies"
        }

        let transform = isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
        UIView.animate(withDuration: 0.2) {
            self.chevronImageView.transform = transform
        }
    }
}
