import UIKit
import SnapKit

final class FirstVC: UIViewController {
    
    // MARK: - Data Models
    private struct TodayEvent {
        let title: String
        let subtitle: String
        let imageName: String
    }
    
    private struct FashionSchool {
        let title: String
        let category: String
        let imageName: String
    }
    
    // MARK: - Mock Data
    private let todayEvents: [TodayEvent] = [
        .init(title: "Paris Fashion Week Casting", subtitle: "High fashion runway selection", imageName: "img1"),
        .init(title: "Milano Editorial Shoot", subtitle: "Exclusive magazine cover session", imageName: "img2"),
        .init(title: "New York Brand Showcase", subtitle: "Commercial streetwear campaign", imageName: "img3"),
        .init(title: "Tokyo Avant-Garde Show", subtitle: "Futuristic conceptual styling", imageName: "img4"),
        .init(title: "London Haute Couture", subtitle: "Designer portfolio expansion", imageName: "img5")
    ]
    
    private let fashionSchools: [FashionSchool] = [
        .init(title: "Classic Runway", category: "Posture & Walk", imageName: "img1"),
        .init(title: "Editorial Posing", category: "Camera Angles", imageName: "img2"),
        .init(title: "High-End Makeup", category: "Beauty Styling", imageName: "img3"),
        .init(title: "Commercial Acting", category: "TV & Commercials", imageName: "img4"),
        .init(title: "Vogue Masterclass", category: "Elite Technique", imageName: "img5"),
        .init(title: "Portfolio Building", category: "Photography", imageName: "img6"),
        .init(title: "Brand Etiquette", category: "PR & Media", imageName: "img7"),
        .init(title: "Fitness & Tone", category: "Body Conditioning", imageName: "img8"),
        .init(title: "Wardrobe Styling", category: "Fashion Theory", imageName: "img9"),
        .init(title: "Runway Choreography", category: "Stage Movement", imageName: "img10"),
        .init(title: "Digital Modeling", category: "Virtual Avatars", imageName: "img11"),
        .init(title: "Commercial Print", category: "Catalog & E-Comm", imageName: "img12"),
        .init(title: "Lingerie & Swim", category: "Specialized Fit", imageName: "img13"),
        .init(title: "Haute Couture Art", category: "Conceptual Art", imageName: "img14"),
        .init(title: "Global Agency Prep", category: "Contract Mastery", imageName: "img15")
    ]
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.backgroundColor = AppColors.background
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.background
        return view
    }()
    
    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "AGENCY HQ"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = AppColors.textPrimary
        return label
    }()
    
    private let headerSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Manage your models, events & academy"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = AppColors.textSecondary
        return label
    }()
    
    private let todaySectionLabel: UILabel = {
        let label = UILabel()
        label.text = "TODAY EVENTS"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = AppColors.textPrimary
        return label
    }()
    
    private lazy var carouselCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(TodayEventCell.self, forCellWithReuseIdentifier: TodayEventCell.identifier)
        return cv
    }()
    
    private let schoolsSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "FASHION SCHOOLS & DISCIPLINES"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = AppColors.textPrimary
        return label
    }()
    
    private lazy var gridCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(SchoolGridCell.self, forCellWithReuseIdentifier: SchoolGridCell.identifier)
        return cv
    }()
    
    private var gridHeightConstraint: Constraint?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateGridHeight()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = AppColors.background
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [headerTitleLabel, headerSubtitleLabel, todaySectionLabel, carouselCollectionView, schoolsSectionLabel, gridCollectionView].forEach {
            contentView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        headerTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        headerSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerTitleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        todaySectionLabel.snp.makeConstraints { make in
            make.top.equalTo(headerSubtitleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        carouselCollectionView.snp.makeConstraints { make in
            make.top.equalTo(todaySectionLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(210)
        }
        
        schoolsSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(carouselCollectionView.snp.bottom).offset(28)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        gridCollectionView.snp.makeConstraints { make in
            make.top.equalTo(schoolsSectionLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(32)
            gridHeightConstraint = make.height.equalTo(500).constraint
        }
    }
    
    private func updateGridHeight() {
        let itemsCount = CGFloat(fashionSchools.count)
        let columns: CGFloat = 2
        let rows = ceil(itemsCount / columns)
        let itemHeight: CGFloat = 110
        let spacing: CGFloat = 12
        let totalHeight = (rows * itemHeight) + ((rows - 1) * spacing)
        gridHeightConstraint?.update(offset: totalHeight)
    }
}

// MARK: - UICollectionViewDataSource & Delegate
extension FirstVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == carouselCollectionView {
            return todayEvents.count
        } else {
            return fashionSchools.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == carouselCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayEventCell.identifier, for: indexPath) as! TodayEventCell
            let event = todayEvents[indexPath.item]
            cell.configure(with: event.title, subtitle: event.subtitle, imageName: event.imageName)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SchoolGridCell.identifier, for: indexPath) as! SchoolGridCell
            let school = fashionSchools[indexPath.item]
            cell.configure(with: school.title, category: school.category, imageName: school.imageName)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == carouselCollectionView {
            let width = collectionView.bounds.width - 48
            return CGSize(width: width, height: 210)
        } else {
            let padding: CGFloat = 16 * 2
            let interitemSpacing: CGFloat = 12
            let totalWidth = collectionView.bounds.width > 0 ? collectionView.bounds.width : (UIScreen.main.bounds.width - padding)
            let itemWidth = (totalWidth - interitemSpacing) / 2
            return CGSize(width: floor(itemWidth), height: 110)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == carouselCollectionView {
            return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        }
        return .zero
    }
}

// MARK: - TodayEventCell (Carousel Item)
private final class TodayEventCell: UICollectionViewCell {
    static let identifier = "TodayEventCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = AppColors.surfaceElevated
        return iv
    }()
    
    private let gradientOverlay: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        return v
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = AppColors.textPrimary
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = AppColors.textSecondary
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.backgroundColor = AppColors.surface
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        
        contentView.addSubview(imageView)
        imageView.addSubview(gradientOverlay)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gradientOverlay.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(subtitleLabel.snp.top).offset(-4)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func configure(with title: String, subtitle: String, imageName: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        imageView.image = UIImage(named: imageName)
    }
}

// MARK: - SchoolGridCell (Grid Item)
private final class SchoolGridCell: UICollectionViewCell {
    static let identifier = "SchoolGridCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = AppColors.surfaceElevated
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = AppColors.textPrimary
        label.numberOfLines = 1
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = AppColors.tintSecondary
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.backgroundColor = AppColors.surface
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configure(with title: String, category: String, imageName: String) {
        titleLabel.text = title
        categoryLabel.text = category
        imageView.image = UIImage(named: imageName)
    }
}

extension FirstVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title: String
        let subtitle: String
        let imageName: String
        
        if collectionView == carouselCollectionView {
            let event = todayEvents[indexPath.item]
            title = event.title
            subtitle = event.subtitle
            imageName = event.imageName
        } else {
            let school = fashionSchools[indexPath.item]
            title = school.title
            subtitle = school.category
            imageName = school.imageName
        }
        
        let viewModel = FashionViewModel(itemTitle: title, itemSubtitle: subtitle, imageName: imageName)
        let fashionVC = FashionVC(viewModel: viewModel)
        navigationController?.pushViewController(fashionVC, animated: true)
    }
}
