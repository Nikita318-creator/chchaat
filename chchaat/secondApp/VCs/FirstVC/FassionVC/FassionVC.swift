import UIKit
import SnapKit

final class FashionVC: UIViewController {
    private let viewModel: FashionViewModel
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        iv.backgroundColor = AppColors.surfaceElevated
        return iv
    }()
    
    private let progressStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 6
        sv.distribution = .fillEqually
        return sv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = AppColors.textSecondary
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(AppColors.textPrimary, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = AppColors.tint
        button.layer.cornerRadius = 14
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var progressBars: [UIView] = []
    
    init(viewModel: FashionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.background
        title = viewModel.itemTitle
        navigationController?.navigationBar.tintColor = AppColors.tint
        
        view.addSubview(imageView)
        view.addSubview(progressStackView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(nextButton)
        
        for _ in 0..<viewModel.totalSteps {
            let bar = UIView()
            bar.backgroundColor = AppColors.separator
            bar.layer.cornerRadius = 2
            progressStackView.addArrangedSubview(bar)
            progressBars.append(bar)
        }
        
        imageView.image = UIImage(named: viewModel.imageName)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(view.snp.width).multipliedBy(0.75)
        }
        
        progressStackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressStackView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(52)
        }
    }
    
    private func bindViewModel() {
        viewModel.onStepChanged = { [weak self] current, total, titleText, descText in
            guard let self = self else { return }
            self.titleLabel.text = titleText
            self.descriptionLabel.text = descText
            
            for (index, bar) in self.progressBars.enumerated() {
                bar.backgroundColor = index <= current ? AppColors.tint : AppColors.separator
            }
            
            self.nextButton.setTitle("Next", for: .normal)
        }
        
        viewModel.onFinished = { [weak self] in
            guard let self = self else { return }
            let menuVC = MenuVC(
                itemTitle: self.viewModel.itemTitle,
                imageName: self.viewModel.imageName
            )
            self.navigationController?.pushViewController(menuVC, animated: true)
        }
    }
    
    @objc private func nextButtonTapped() {
        viewModel.nextStep()
    }
}
