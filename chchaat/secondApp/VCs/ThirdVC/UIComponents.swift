//
//  UIComponents.swift
//  chchaat
//
//  Shared UI helpers: asset names, gradient button, fade overlay, toast, shake.
//

import UIKit
import SnapKit

// MARK: - Assets

enum AppAssets {
    /// Images used by the onboarding slides (one per slide). Reorder freely.
    static let onboardingImages = ["img1", "img2", "img3", "img4", "img5"]
    /// Banner on top of the level grid.
    static let bannerImage = "img6"
    /// Shown on the "level complete" card (rotates by level).
    static let victoryImages = ["img7", "img8", "img9", "img10", "img11", "img12", "img13", "img14", "img15"]

    static func victoryImage(for level: Int) -> UIImage? {
        UIImage(named: victoryImages[level % victoryImages.count])
    }
}

// MARK: - Gradient button

final class GradientButton: UIButton {

    private let gradientLayer = AppGradients.primaryButton

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = 16
        clipsToBounds = true
        setTitleColor(AppColors.textPrimary, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    override var isHighlighted: Bool {
        didSet { alpha = isHighlighted ? 0.8 : 1.0 }
    }
}

// MARK: - Fade overlay (transparent -> background)

final class FadeView: UIView {

    override class var layerClass: AnyClass { CAGradientLayer.self }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        if let gradient = layer as? CAGradientLayer {
            gradient.colors = [
                AppColors.background.withAlphaComponent(0.0).cgColor,
                AppColors.background.withAlphaComponent(0.92).cgColor
            ]
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension UIButton {
    func applySecondaryStyle() {
        backgroundColor = AppColors.surfaceElevated
        setTitleColor(AppColors.textPrimary, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = AppColors.separator.cgColor
    }
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.values = [-6, 6, -4, 4, -2, 2, 0]
        animation.duration = 0.35
        layer.add(animation, forKey: "shake")
    }
}

extension UIViewController {
    func showToast(_ message: String) {
        let container = UIView()
        container.backgroundColor = AppColors.surfaceElevated
        container.layer.cornerRadius = 14
        container.layer.borderWidth = 1
        container.layer.borderColor = AppColors.separator.cgColor
        container.alpha = 0

        let label = UILabel()
        label.text = message
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        container.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
        }

        view.addSubview(container)
        container.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(24)
            make.leading.greaterThanOrEqualToSuperview().offset(24)
        }

        UIView.animate(withDuration: 0.2, animations: {
            container.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 1.6, options: [], animations: {
                container.alpha = 0
            }, completion: { _ in
                container.removeFromSuperview()
            })
        })
    }
}
