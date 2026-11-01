//
//  ThreadReplyCell.swift
//  chchaat
//
//

import UIKit
import SnapKit

// MARK: - Thread Reply Cell
final class ThreadReplyCell: UITableViewCell {
    static let identifier = "ThreadReplyCell"

    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 14
        iv.clipsToBounds = true
        iv.backgroundColor = AppColors.surfaceElevated
        return iv
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = AppColors.textPrimary
        return label
    }()

    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = AppColors.textMuted
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = AppColors.textSecondary
        label.numberOfLines = 0
        return label
    }()

    private let verticalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.separator
        return view
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

        contentView.addSubview(verticalLineView)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(authorLabel)
        contentView.addSubview(timestampLabel)
        contentView.addSubview(contentLabel)

        verticalLineView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(36)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(2)
        }

        avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(52)
            make.top.equalToSuperview().offset(8)
            make.size.equalTo(28)
        }

        authorLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(10)
            make.centerY.equalTo(avatarImageView)
        }

        timestampLabel.snp.makeConstraints { make in
            make.leading.equalTo(authorLabel.snp.trailing).offset(8)
            make.centerY.equalTo(authorLabel)
        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(6)
            make.leading.equalTo(avatarImageView)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-10)
        }
    }

    func configure(with reply: ThreadReply) {
        avatarImageView.image = UIImage(named: reply.authorAvatar)
        authorLabel.text = reply.authorName
        timestampLabel.text = reply.timestamp
        contentLabel.text = reply.content
    }
}
