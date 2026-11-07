//
//  PhotoPreviewViewController.swift
//  chchaat
//

import UIKit
import SnapKit
import Photos

final class PhotoPreviewViewController: UIViewController {
    
    private let image: UIImage
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var closeButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        btn.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        return btn
    }()
    
    private lazy var downloadButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        btn.setImage(UIImage(systemName: "square.and.arrow.down", withConfiguration: config), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(didTapDownload), for: .touchUpInside)
        return btn
    }()
    
    // Переменные для трансформаций
    private var currentScale: CGFloat = 1.0
    private var currentRotation: CGFloat = 0.0
    private var currentTranslation: CGPoint = .zero
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.alpha = 1.0
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        containerView.addSubview(imageView)
        view.addSubview(closeButton)
        view.addSubview(downloadButton)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.image = image
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(UIScreen.main.bounds.width)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(40)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.trailing.equalTo(closeButton.snp.leading).offset(-12)
            make.width.height.equalTo(40)
        }
    }
    
    private func setupGestures() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        pinch.delegate = self
        containerView.addGestureRecognizer(pinch)
        
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        rotation.delegate = self
        containerView.addGestureRecognizer(rotation)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = self
        containerView.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        tap.numberOfTapsRequired = 2
        containerView.addGestureRecognizer(tap)
    }
    
    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began, .changed:
            currentScale *= gesture.scale
            gesture.scale = 1.0
            updateTransform()
        case .ended, .cancelled:
            if currentScale < 1.0 {
                resetTransform(animated: true)
            }
        default:
            break
        }
    }
    
    @objc private func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        switch gesture.state {
        case .began, .changed:
            currentRotation += gesture.rotation
            gesture.rotation = 0.0
            updateTransform()
        case .ended, .cancelled:
            break
        default:
            break
        }
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        switch gesture.state {
        case .began, .changed:
            currentTranslation = CGPoint(
                x: currentTranslation.x + translation.x,
                y: currentTranslation.y + translation.y
            )
            gesture.setTranslation(.zero, in: view)
            updateTransform()
        case .ended, .cancelled:
            // Если сильно смахнули вниз или вверх при масштабе близком к 1, закрываем вьюху
            if abs(currentTranslation.y) > 150 && currentScale <= 1.2 {
                didTapClose()
            }
        default:
            break
        }
    }
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            if self.currentScale > 1.0 {
                self.resetTransformValues()
            } else {
                self.currentScale = 2.0
            }
            self.updateTransform()
        }
    }
    
    private func updateTransform() {
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: currentTranslation.x, y: currentTranslation.y)
        transform = transform.scaledBy(x: currentScale, y: currentScale)
        transform = transform.rotated(by: currentRotation)
        containerView.transform = transform
    }
    
    private func resetTransform(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.resetTransformValues()
                self.updateTransform()
            }
        } else {
            resetTransformValues()
            updateTransform()
        }
    }
    
    private func resetTransformValues() {
        currentScale = 1.0
        currentRotation = 0.0
        currentTranslation = .zero
    }
    
    @objc private func didTapClose() {
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView.alpha = 0
            self.containerView.alpha = 0
            self.closeButton.alpha = 0
            self.downloadButton.alpha = 0
        }) { _ in
            self.dismiss(animated: false)
        }
    }
    
    @objc private func didTapDownload() {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] status in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard status == .authorized || status == .limited else {
                    self.showAlert(title: "Access Denied", message: "Please allow photo library access in Settings to save images.")
                    return
                }
                
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: self.image)
                }) { success, error in
                    DispatchQueue.main.async {
                        if success {
                            self.showToast(message: "Saved to Photos!")
                        } else {
                            self.showAlert(title: "Error", message: error?.localizedDescription ?? "Failed to save image.")
                        }
                    }
                }
            }
        }
    }
    
    private func showToast(message: String) {
        let toast = UILabel()
        toast.text = message
        toast.font = .systemFont(ofSize: 14, weight: .semibold)
        toast.textColor = .white
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toast.textAlignment = .center
        toast.layer.cornerRadius = 10
        toast.clipsToBounds = true
        
        view.addSubview(toast)
        toast.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.width.equalTo(160)
            make.height.equalTo(36)
        }
        
        toast.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            toast.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 1.5, options: [], animations: {
                toast.alpha = 0
            }) { _ in
                toast.removeFromSuperview()
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension PhotoPreviewViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
