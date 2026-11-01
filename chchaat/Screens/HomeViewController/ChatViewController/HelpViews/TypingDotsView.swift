//
//  TypingDotsView.swift
//  chchaat
//
//

import UIKit
import SnapKit

// MARK: - Три точки
final class TypingDotsView: UIView {
    private let dots: [UIView] = (0..<3).map { _ in
        let v = UIView()
        v.backgroundColor = AppColors.textSecondary
        v.layer.cornerRadius = 3
        v.snp.makeConstraints { $0.width.height.equalTo(6) }
        return v
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        let stack = UIStackView(arrangedSubviews: dots)
        stack.spacing = 4
        addSubview(stack)
        stack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func start() {
        for (i, dot) in dots.enumerated() {
            let anim = CABasicAnimation(keyPath: "opacity")
            anim.fromValue = 0.25
            anim.toValue = 1.0
            anim.duration = 0.5
            anim.autoreverses = true
            anim.repeatCount = .infinity
            anim.beginTime = dot.layer.convertTime(CACurrentMediaTime(), from: nil) + Double(i) * 0.18
            anim.fillMode = .backwards
            dot.layer.add(anim, forKey: "pulse")
        }
    }

    func stop() { dots.forEach { $0.layer.removeAllAnimations() } }
}
