//  ChatAudioMessageCell.swift
//  chchaat

import UIKit
import SnapKit
import AVFoundation

final class ChatAudioMessageCell: UITableViewCell, AVAudioPlayerDelegate {
    static let reuseId = "ChatAudioMessageCell"

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()

    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        view.backgroundColor = AppColors.bubbleIncoming
        return view
    }()

    private lazy var playButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        btn.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        btn.tintColor = AppColors.tint
        btn.addTarget(self, action: #selector(didTapPlay), for: .touchUpInside)
        return btn
    }()

    private let waveformView = AudioWaveformView()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.textColor = AppColors.textSecondary
        label.text = "0:00"
        return label
    }()
    
    private let messageTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = AppColors.textMuted
        return label
    }()

    private var audioPlayer: AVAudioPlayer?
    private var audioURL: URL?
    private var displayLink: CADisplayLink?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        super.prepareForReuse()
        stopAudio()
    }

    private func setupLayout() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(bubbleView)
        bubbleView.addSubview(playButton)
        bubbleView.addSubview(waveformView)
        bubbleView.addSubview(timeLabel)
        bubbleView.addSubview(messageTimeLabel)

        bubbleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().inset(6)
            make.width.equalTo(240)
            make.leading.equalToSuperview().offset(16)
        }

        playButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview().offset(-8)
            make.width.height.equalTo(36)
        }

        waveformView.snp.makeConstraints { make in
            make.leading.equalTo(playButton.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(14)
            make.centerY.equalTo(playButton)
            make.height.equalTo(24)
        }

        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(waveformView)
            make.top.equalTo(waveformView.snp.bottom).offset(4)
            make.bottom.equalToSuperview().inset(8)
        }

        messageTimeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(14)
            make.centerY.equalTo(timeLabel)
        }
    }

    func configure(with message: MessageModel) {
        messageTimeLabel.text = Self.timeFormatter.string(from: message.timestamp)
        
        if let path = message.audioLocalPath {
            audioURL = URL(fileURLWithPath: path)
            setupPlayer()
        }
    }

    private func setupPlayer() {
        guard let url = audioURL else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            updateTimeLabel(currentTime: 0, duration: audioPlayer?.duration ?? 0)
        } catch {
            print("❌ [AudioPlayer] Error setup: \(error)")
        }
    }

    @objc private func didTapPlay() {
        guard let player = audioPlayer else { return }
        
        if player.isPlaying {
            player.pause()
            stopDisplayLink()
            setPlayButtonState(isPlaying: false)
        } else {
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try? AVAudioSession.sharedInstance().setActive(true)
            player.play()
            startDisplayLink()
            setPlayButtonState(isPlaying: true)
        }
    }

    private func setPlayButtonState(isPlaying: Bool) {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let imageName = isPlaying ? "pause.fill" : "play.fill"
        playButton.setImage(UIImage(systemName: imageName, withConfiguration: config), for: .normal)
    }

    private func startDisplayLink() {
        stopDisplayLink()
        displayLink = CADisplayLink(target: self, selector: #selector(updateProgress))
        displayLink?.add(to: .current, forMode: .common)
    }

    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func updateProgress() {
        guard let player = audioPlayer else { return }
        let currentTime = player.currentTime
        let duration = player.duration
        
        if duration > 0 {
            waveformView.progress = Float(currentTime / duration)
        }
        updateTimeLabel(currentTime: currentTime, duration: duration)
    }

    private func updateTimeLabel(currentTime: TimeInterval, duration: TimeInterval) {
        let currentFormatted = formatTime(currentTime)
        let totalFormatted = formatTime(duration)
        timeLabel.text = "\(currentFormatted) / \(totalFormatted)"
    }

    private func formatTime(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func stopAudio() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        stopDisplayLink()
        setPlayButtonState(isPlaying: false)
        waveformView.progress = 0
        if let duration = audioPlayer?.duration {
            updateTimeLabel(currentTime: 0, duration: duration)
        }
    }

    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopAudio()
    }
}
