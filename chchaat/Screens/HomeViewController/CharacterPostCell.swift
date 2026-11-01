//
//  CharacterPostCell.swift
//  chchaat
//

import UIKit
import SnapKit

// MARK: - Feed Cell
final class CharacterPostCell: UITableViewCell {
    static let identifier = "CharacterPostCell"

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.surface
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()

    private let headerView: UIView = {
        let view = UIView()
        return view
    }()

    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = AppColors.surfaceElevated
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        return iv
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = AppColors.textPrimary
        return label
    }()

    private let statusBadgeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = AppColors.tintSecondary
        label.text = "● Online"
        return label
    }()

    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = AppColors.surfaceElevated
        iv.clipsToBounds = true
        return iv
    }()

    private let infoContainerView: UIView = {
        let view = UIView()
        return view
    }()

    private let taglineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textColor = AppColors.tint
        return label
    }()

    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = AppColors.textSecondary
        label.numberOfLines = 2
        return label
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
        containerView.addSubview(headerView)
        headerView.addSubview(avatarImageView)
        headerView.addSubview(nameLabel)
        headerView.addSubview(statusBadgeLabel)

        containerView.addSubview(postImageView)
        containerView.addSubview(infoContainerView)
        infoContainerView.addSubview(taglineLabel)
        infoContainerView.addSubview(bioLabel)

        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }

        avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            make.top.equalToSuperview().offset(12)
        }

        statusBadgeLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.bottom.equalToSuperview().offset(-12)
        }

        postImageView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(360)
        }

        infoContainerView.snp.makeConstraints { make in
            make.top.equalTo(postImageView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        taglineLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(taglineLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    func configure(with character: AICharacter) {
        nameLabel.text = "\(character.name), \(character.age)"
        taglineLabel.text = character.tagline.uppercased()
        bioLabel.text = character.bio
    }
}
