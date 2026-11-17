import UIKit
import SnapKit

final class SecondVC: UIViewController {
    
    private struct Item {
        let uiTitle: String
        let uiSubtitle: String
        let parsingTitle: String
        let imageName: String
    }
    
    private let items: [Item] = [
        .init(uiTitle: "Elite Runway & Posture Walk", uiSubtitle: "Professional posture and centerline walk mastery", parsingTitle: "Classic Runway", imageName: "img1"),
        .init(uiTitle: "Camera Angles & Editorial Posing", uiSubtitle: "Dynamic body geometry and micro-expressions", parsingTitle: "Editorial Posing", imageName: "img2"),
        .init(uiTitle: "Luxury Beauty & High-End Makeup", uiSubtitle: "Skincare preparation and studio lighting prep", parsingTitle: "High-End Makeup", imageName: "img3"),
        .init(uiTitle: "Commercial Acting & Screen Presence", uiSubtitle: "On-camera dialogue and brand storytelling", parsingTitle: "Commercial Acting", imageName: "img4"),
        .init(uiTitle: "Vogue Elite Masterclass", uiSubtitle: "Advanced runway technique and stage command", parsingTitle: "Vogue Masterclass", imageName: "img5"),
        .init(uiTitle: "Portfolio & Zed Card Building", uiSubtitle: "Professional book curation and test shoots", parsingTitle: "Portfolio Building", imageName: "img6"),
        .init(uiTitle: "Brand PR & Red Carpet Etiquette", uiSubtitle: "Public relations and professional conduct", parsingTitle: "Brand Etiquette", imageName: "img7"),
        .init(uiTitle: "Fitness, Tone & Body Conditioning", uiSubtitle: "Stamina, core stability and athletic recovery", parsingTitle: "Fitness & Tone", imageName: "img8"),
        .init(uiTitle: "Wardrobe Styling & Fashion Theory", uiSubtitle: "Silhouette geometry and fabric drapery", parsingTitle: "Wardrobe Styling", imageName: "img9"),
        .init(uiTitle: "Runway Choreography & Stage Flow", uiSubtitle: "Multi-model formations and musical pacing", parsingTitle: "Runway Choreography", imageName: "img10"),
        .init(uiTitle: "Digital Avatars & 3D Modeling", uiSubtitle: "Motion capture and metaverse fashion shows", parsingTitle: "Digital Modeling", imageName: "img11"),
        .init(uiTitle: "Commercial Print & E-Comm Catalog", uiSubtitle: "High-volume retail poses and rapid changes", parsingTitle: "Commercial Print", imageName: "img12"),
        .init(uiTitle: "Lingerie, Swim & Specialized Fit", uiSubtitle: "Strict fitness discipline and delicate fabrics", parsingTitle: "Lingerie & Swim", imageName: "img13"),
        .init(uiTitle: "Haute Couture Sculptural Art", uiSubtitle: "Wearable gallery pieces and surreal design", parsingTitle: "Haute Couture Art", imageName: "img14"),
        .init(uiTitle: "Global Agency Contracts & Prep", uiSubtitle: "Mother agency relations and international visas", parsingTitle: "Global Agency Prep", imageName: "img15")
    ]
    
    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "ACADEMY DIRECTORY"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = AppColors.textPrimary
        return label
    }()
    
    private let headerSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Direct insights & interactive knowledge base"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = AppColors.textSecondary
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(SecondCell.self, forCellWithReuseIdentifier: SecondCell.identifier)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.background
        title = "Directory Hub"
        navigationController?.navigationBar.tintColor = AppColors.tint
        
        [headerTitleLabel, headerSubtitleLabel, collectionView].forEach {
            view.addSubview($0)
        }
        
        headerTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        headerSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerTitleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerSubtitleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}

// MARK: - UICollectionViewDataSource & Delegate
extension SecondVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SecondCell.identifier, for: indexPath) as? SecondCell else {
            return UICollectionViewCell()
        }
        let item = items[indexPath.item]
        cell.configure(with: item.uiTitle, subtitle: item.uiSubtitle, imageName: item.imageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        // Передаем parsingTitle для корректного парсинга во вьюмодели, а также флаг showNextButton: true
        let factVC = InterestingFactVC(
            itemTitle: item.parsingTitle,
            imageName: item.imageName,
            showNextButton: true
        )
        navigationController?.pushViewController(factVC, animated: true)
    }
}

// MARK: - SecondCell (Elongated Single Column Cell)
private final class SecondCell: UICollectionViewCell {
    static let identifier = "SecondCell"
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 28 // Закругленная аватарка слева
        iv.backgroundColor = AppColors.surfaceElevated
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = AppColors.textSecondary
        label.numberOfLines = 2
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
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(56)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(14)
            make.trailing.equalToSuperview().inset(16)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(14)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().inset(14)
        }
    }
    
    func configure(with title: String, subtitle: String, imageName: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        avatarImageView.image = UIImage(named: imageName)
    }
}
