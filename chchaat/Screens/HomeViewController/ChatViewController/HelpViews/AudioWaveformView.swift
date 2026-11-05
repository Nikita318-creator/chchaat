//  AudioWaveformView.swift
//  chchaat

import UIKit
import SnapKit

final class AudioWaveformView: UIView {
    private var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 3
        sv.alignment = .center
        sv.distribution = .fillEqually
        return sv
    }()
    
    private var barViews: [UIView] = []
    
    var progress: Float = 0.0 {
        didSet { updateProgress() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        // Рандомно сгенерированная аудио волна для каждого сообщения
        let heights: [CGFloat] = [0.3, 0.6, 0.4, 0.8, 1.0, 0.5, 0.7, 0.9, 0.4, 0.6, 0.8, 0.3, 0.7, 0.9, 0.5, 0.8, 0.4, 0.6, 1.0, 0.7, 0.3, 0.5, 0.8, 0.6, 0.4, 0.7]
        
        for h in heights {
            let bar = UIView()
            bar.backgroundColor = AppColors.textMuted.withAlphaComponent(0.4)
            bar.layer.cornerRadius = 1.5
            bar.snp.makeConstraints { make in
                make.height.equalTo(24 * h).priority(.high)
                make.width.equalTo(3)
            }
            barViews.append(bar)
            stackView.addArrangedSubview(bar)
        }
    }
    
    private func updateProgress() {
        let activeCount = Int(Float(barViews.count) * progress)
        for (index, bar) in barViews.enumerated() {
            if index <= activeCount {
                bar.backgroundColor = AppColors.tint
            } else {
                bar.backgroundColor = AppColors.textMuted.withAlphaComponent(0.4)
            }
        }
    }
}
