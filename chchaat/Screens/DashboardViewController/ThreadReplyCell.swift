//
//  ThreadReplyCell.swift
//  chchaat
//
//

import UIKit
import SnapKit

final class ThreadReplyCell: UITableViewCell {
    static let identifier = "ThreadReplyCell"

    var onLikeTapped: (() -> Void)?

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

    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 13, weight: .medium)
        button.setImage(UIImage(systemName: "heart", withConfiguration: config), for: .normal)
        button.tintColor = AppColors.textMuted
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return button
    }()

    private let likesCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.textColor = AppColors.textMuted
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
        contentView.addSubview(likeButton)
        contentView.addSubview(likesCountLabel)

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

        likeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(authorLabel)
            make.size.equalTo(20)
        }

        likesCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(likeButton.snp.leading).offset(-4)
            make.centerY.equalTo(likeButton)
        }
    }

    @objc private func didTapLike() {
        onLikeTapped?()
    }

    func configure(with reply: ThreadReply, baseLikes: Int) {
        if reply.id.hasPrefix("user_comm_") {
            avatarImageView.image = UIImage(systemName: "person.crop.circle.fill") // или любая дефолтная системная иконка-плейсхолдер
            avatarImageView.tintColor = AppColors.textMuted
        } else {
            avatarImageView.image = UIImage(named: reply.authorAvatar)
        }
        authorLabel.text = reply.authorName
        timestampLabel.text = reply.timestamp
        contentLabel.text = reply.content

        let isLiked = InteractionManager.shared.isLiked(id: reply.id)
        let totalLikes = baseLikes + (isLiked ? 1 : 0)
        likesCountLabel.text = "\(totalLikes)"

        let heartName = isLiked ? "heart.fill" : "heart"
        let config = UIImage.SymbolConfiguration(pointSize: 13, weight: .medium)
        likeButton.setImage(UIImage(systemName: heartName, withConfiguration: config), for: .normal)
        likeButton.tintColor = isLiked ? AppColors.destructive : AppColors.textMuted
    }
}
