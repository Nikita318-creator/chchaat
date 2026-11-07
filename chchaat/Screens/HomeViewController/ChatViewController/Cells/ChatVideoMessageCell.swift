//
//  ChatVideoMessageCell.swift
//  chchaat
//

import UIKit
import SnapKit
import AVKit

final class ChatVideoMessageCell: UITableViewCell {
    static let reuseId = "ChatVideoMessageCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.backgroundColor = AppColors.surface
        return view
    }()
    
    private let videoThumbnailView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    private let playButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        btn.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        btn.layer.cornerRadius = 24
        btn.clipsToBounds = true
        btn.isUserInteractionEnabled = false
        return btn
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
        containerView.addSubview(videoThumbnailView)
        videoThumbnailView.addSubview(playButton)
        containerView.addSubview(captionLabel)
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().inset(6)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(240)
        }
        
        videoThumbnailView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(180)
        }
        
        playButton.snp.makeConstraints { make in
            make.center.equalTo(videoThumbnailView)
            make.width.height.equalTo(48)
        }
        
        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(videoThumbnailView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview().inset(8)
        }
    }
    
    func configure(with message: MessageModel) {
        captionLabel.text = message.text
        if let path = message.mediaLocalPath {
            let url = URL(fileURLWithPath: path)
            videoThumbnailView.image = generateThumbnail(for: url) ?? UIImage(systemName: "video.fill")
        } else {
            videoThumbnailView.image = UIImage(systemName: "video.fill")
            videoThumbnailView.tintColor = AppColors.textSecondary
        }
    }
    
    private func generateThumbnail(for url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        do {
            let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            return nil
        }
    }
}
