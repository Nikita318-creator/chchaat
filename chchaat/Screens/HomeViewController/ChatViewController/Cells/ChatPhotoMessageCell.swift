//
//  ChatPhotoMessageCell.swift
//  chchaat
//

import UIKit
import SnapKit

final class ChatPhotoMessageCell: UITableViewCell {
    static let reuseId = "ChatPhotoMessageCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.backgroundColor = AppColors.surface
        return view
    }()
    
    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = AppColors.textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(photoImageView)
        containerView.addSubview(captionLabel)
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().inset(6)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(240)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(180)
        }
        
        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview().inset(8)
        }
    }
    
    func configure(with message: MessageModel) {
        captionLabel.text = message.text
        if let path = message.mediaLocalPath, let image = UIImage(contentsOfFile: path) {
            photoImageView.image = image
        } else {
            photoImageView.image = UIImage(systemName: "photo")
            photoImageView.tintColor = AppColors.textSecondary
        }
    }
}
