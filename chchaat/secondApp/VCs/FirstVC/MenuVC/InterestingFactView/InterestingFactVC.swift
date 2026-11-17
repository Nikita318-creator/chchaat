import UIKit
import SnapKit

final class InterestingFactVC: UIViewController {
    
    private let viewModel: InterestingFactViewModel
    private let showNextButton: Bool
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let headerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        iv.backgroundColor = AppColors.surfaceElevated
        return iv
    }()
    
    private let categoryBadgeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = AppColors.tintSecondary
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    private let introLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = AppColors.textSecondary
        label.numberOfLines = 0
        return label
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16
        sv.alignment = .fill
        return sv
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next: Take Quiz", for: .normal)
        button.setTitleColor(AppColors.textPrimary, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = AppColors.tint
        button.layer.cornerRadius = 14
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init(itemTitle: String, imageName: String, showNextButton: Bool = false) {
        self.viewModel = InterestingFactViewModel(itemTitle: itemTitle, imageName: imageName)
        self.showNextButton = showNextButton
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populateData()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.background
        title = "Insights & Lore"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [headerImageView, categoryBadgeLabel, titleLabel, introLabel, stackView].forEach {
            contentView.addSubview($0)
        }
        
        if showNextButton {
            view.addSubview(nextButton)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            if showNextButton {
                make.bottom.equalTo(nextButton.snp.top).offset(-12)
            } else {
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            }
        }
        
        if showNextButton {
            nextButton.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(24)
                make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
                make.height.equalTo(52)
            }
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        headerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(220)
        }
        
        categoryBadgeLabel.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryBadgeLabel.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        introLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(introLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(40)
        }
    }
    
    private func populateData() {
        headerImageView.image = UIImage(named: viewModel.imageName)
        categoryBadgeLabel.text = viewModel.categoryBadge.uppercased()
        titleLabel.text = viewModel.headerTitle
        introLabel.text = viewModel.introText
        
        for section in viewModel.sections {
            let cardView = createSectionCard(for: section)
            stackView.addArrangedSubview(cardView)
        }
    }
    
    private func createSectionCard(for section: InterestingFactViewModel.Section) -> UIView {
        let container = UIView()
        container.backgroundColor = section.isHighlighted ? AppColors.surfaceElevated : AppColors.surface
        container.layer.cornerRadius = 16
        container.layer.borderWidth = section.isHighlighted ? 1 : 0
        container.layer.borderColor = section.isHighlighted ? AppColors.tint.cgColor : UIColor.clear.cgColor
        
        let innerStack = UIStackView()
        innerStack.axis = .vertical
        innerStack.spacing = 10
        innerStack.alignment = .fill
        
        container.addSubview(innerStack)
        innerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        let heading = section.heading
        let headingLabel = UILabel()
        headingLabel.text = heading
        headingLabel.font = .systemFont(ofSize: 18, weight: .bold)
        headingLabel.textColor = AppColors.textPrimary
        innerStack.addArrangedSubview(headingLabel)
        
        let bodyLabel = UILabel()
        bodyLabel.text = section.body
        bodyLabel.font = .systemFont(ofSize: 14, weight: .regular)
        bodyLabel.textColor = AppColors.textSecondary
        bodyLabel.numberOfLines = 0
        innerStack.addArrangedSubview(bodyLabel)
        
        if let quote = section.quote {
            let quoteContainer = UIView()
            quoteContainer.backgroundColor = AppColors.background
            quoteContainer.layer.cornerRadius = 10
            
            let quoteLabel = UILabel()
            quoteLabel.text = "“\(quote)”"
            quoteLabel.font = .italicSystemFont(ofSize: 13)
            quoteLabel.textColor = AppColors.tintSecondary
            quoteLabel.numberOfLines = 0
            
            quoteContainer.addSubview(quoteLabel)
            quoteLabel.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(14)
            }
            
            innerStack.addArrangedSubview(quoteContainer)
        }
        
        return container
    }
    
    @objc private func nextButtonTapped() {
        let quizVC = QuizVC(itemTitle: viewModel.itemTitle)
        navigationController?.pushViewController(quizVC, animated: true)
    }
}
