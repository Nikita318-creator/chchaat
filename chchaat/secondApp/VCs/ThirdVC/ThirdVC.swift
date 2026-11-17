import UIKit
import SnapKit

// MARK: - Onboarding ViewController

final class OnboardingVC: UIViewController {
    
    private let slides: [(title: String, subtitle: String, imageName: String)] = [
        (
            "The Fashion Realm in Peril",
            "A dark monochrome shadow has swept across the global fashion capitals. All iconic styles, textures, and haute couture have been scrambled into chaotic stacks.",
            AppAssets.onboardingImages.indices.contains(0) ? AppAssets.onboardingImages[0] : "img1"
        ),
        (
            "The Power of Matching",
            "Legend speaks of an ancient art—Majonga. By pairing identical elements that lie free on top of the mystical stacks, we can restore harmony and color to the runway.",
            AppAssets.onboardingImages.indices.contains(1) ? AppAssets.onboardingImages[1] : "img2"
        ),
        (
            "100 Levels of Style",
            "Your journey spans 100 increasingly intricate layers of design. Each solved puzzle unlocks the next masterpiece, pushing back the monochrome curse step by step.",
            AppAssets.onboardingImages.indices.contains(2) ? AppAssets.onboardingImages[2] : "img3"
        ),
        (
            "Tools of the Master Stylist",
            "Stuck in a complex stack? Use Hints to spot hidden pairs, or Shuffle the remaining pieces to keep your combo alive. Perfection awaits!",
            AppAssets.onboardingImages.indices.contains(3) ? AppAssets.onboardingImages[3] : "img4"
        ),
        (
            "Save the World of Fashion",
            "The models are waiting, the runways are dark, and the spotlight is yours. Step into the grid, trust your instinct, and let's restore high fashion!",
            AppAssets.onboardingImages.indices.contains(4) ? AppAssets.onboardingImages[4] : "img5"
        )
    ]
    
    private var currentIndex = 0
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 24
        iv.backgroundColor = AppColors.surfaceElevated
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = AppColors.textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = AppColors.tintSecondary
        pc.pageIndicatorTintColor = AppColors.separator
        return pc
    }()
    
    private let actionButton = GradientButton()
    
    var onFinished: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        
        setupUI()
        updateSlide(animated: false)
    }
    
    private func setupUI() {
        pageControl.numberOfPages = slides.count
        pageControl.addTarget(self, action: #selector(didChangePage), for: .valueChanged)
        
        actionButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(pageControl)
        view.addSubview(actionButton)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(view.snp.width).multipliedBy(0.85)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        actionButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(52)
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(actionButton.snp.top).offset(-20)
            make.centerX.equalToSuperview()
        }
    }
    
    private func updateSlide(animated: Bool) {
        let slide = slides[currentIndex]
        titleLabel.text = slide.title
        subtitleLabel.text = slide.subtitle
        imageView.image = UIImage(named: slide.imageName) ?? UIImage(systemName: "sparkles")
        pageControl.currentPage = currentIndex
        
        let isLast = currentIndex == slides.count - 1
        actionButton.setTitle(isLast ? "Start Styling" : "Continue", for: .normal)
        
        if animated {
            let transition = CATransition()
            transition.type = .fade
            transition.duration = 0.25
            imageView.layer.add(transition, forKey: nil)
        }
    }
    
    @objc private func didTapNext() {
        if currentIndex < slides.count - 1 {
            currentIndex += 1
            updateSlide(animated: true)
        } else {
            ProgressStore.shared.hasSeenOnboarding = true
            onFinished?()
        }
    }
    
    @objc private func didChangePage() {
        currentIndex = pageControl.currentPage
        updateSlide(animated: true)
    }
}

// MARK: - Level Cell for CollectionView

final class LevelCell: UICollectionViewCell {
    static let reuseId = "LevelCell"
    
    private let numberLabel = UILabel()
    private let iconImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1
        
        numberLabel.font = .systemFont(ofSize: 18, weight: .bold)
        numberLabel.textAlignment = .center
        
        iconImageView.contentMode = .scaleAspectFit
        
        contentView.addSubview(numberLabel)
        contentView.addSubview(iconImageView)
        
        numberLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(24)
        }
    }
    
    func configure(level: Int, isCompleted: Bool, isUnlocked: Bool) {
        numberLabel.text = "\(level)"
        
        if isCompleted {
            contentView.backgroundColor = AppColors.tintSecondary
            contentView.layer.borderColor = AppColors.link.cgColor
            numberLabel.textColor = AppColors.textPrimary
            numberLabel.isHidden = true
            iconImageView.isHidden = false
            iconImageView.image = UIImage(systemName: "checkmark.circle.fill")
            iconImageView.tintColor = AppColors.textPrimary
        } else if isUnlocked {
            contentView.backgroundColor = AppColors.surface
            contentView.layer.borderColor = AppColors.separator.cgColor
            numberLabel.textColor = AppColors.textPrimary
            numberLabel.isHidden = false
            iconImageView.isHidden = true
        } else {
            contentView.backgroundColor = AppColors.surface.withAlphaComponent(0.4)
            contentView.layer.borderColor = AppColors.separator.withAlphaComponent(0.2).cgColor
            numberLabel.textColor = AppColors.textMuted
            numberLabel.isHidden = false
            iconImageView.isHidden = true
        }
    }
}

// MARK: - ThirdVC (Main Container & Level Grid)

final class ThirdVC: UIViewController {

    private let store = ProgressStore.shared
    private var backgroundGradient: CAGradientLayer?

    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.surface
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColors.separator.cgColor
        return view
    }()

    private let bannerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.image = UIImage(named: AppAssets.bannerImage) ?? UIImage(systemName: "crown.fill")
        iv.backgroundColor = AppColors.surfaceElevated
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Fashion Majonga"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = AppColors.textPrimary
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a level to restore the runway style"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = AppColors.textSecondary
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 12
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(LevelCell.self, forCellWithReuseIdentifier: LevelCell.reuseId)
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        
        if !store.hasSeenOnboarding {
            showOnboarding()
        } else {
            setupUI()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        collectionView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient?.frame = view.bounds
    }

    private func setupBackground() {
        view.backgroundColor = AppColors.background
        let gradient = AppGradients.chatBackground(for: view.bounds)
        view.layer.insertSublayer(gradient, at: 0)
        backgroundGradient = gradient
    }

    private func showOnboarding() {
        let onboarding = OnboardingVC()
        onboarding.modalPresentationStyle = .fullScreen
        onboarding.onFinished = { [weak self] in
            onboarding.dismiss(animated: true) {
                self?.setupUI()
            }
        }
        present(onboarding, animated: false)
    }

    private func setupUI() {
        view.addSubview(headerView)
        headerView.addSubview(bannerImageView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(subtitleLabel)

        view.addSubview(collectionView)

        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(110)
        }

        bannerImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(86)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bannerImageView.snp.top).offset(10)
            make.leading.equalTo(bannerImageView.snp.trailing).offset(14)
            make.trailing.equalToSuperview().inset(12)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(12)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension ThirdVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProgressStore.totalLevels
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LevelCell.reuseId, for: indexPath) as? LevelCell else {
            return UICollectionViewCell()
        }
        
        let level = indexPath.item + 1
        let isCompleted = store.isCompleted(level)
        let isUnlocked = store.isUnlocked(level)
        
        cell.configure(level: level, isCompleted: isCompleted, isUnlocked: isUnlocked)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 12
        let itemsPerRow: CGFloat = 5
        let totalSpacing = spacing * (itemsPerRow - 1)
        let availableWidth = collectionView.bounds.width - totalSpacing
        let width = floor(availableWidth / itemsPerRow)
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let level = indexPath.item + 1
        
        guard store.isUnlocked(level) else {
            showToast("Complete previous levels to unlock level \(level)")
            return
        }

        let gameVC = MajongaVC(level: level)
        navigationController?.pushViewController(gameVC, animated: true)
    }
}
