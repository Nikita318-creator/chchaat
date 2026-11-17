import UIKit
import SnapKit

final class MenuVC: UIViewController {
    
    private let itemTitle: String
    private let imageName: String
    
    private let headerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.backgroundColor = AppColors.surfaceElevated
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.numberOfLines = 2
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Masterclass completed. Choose your next activity:"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = AppColors.textSecondary
        label.numberOfLines = 3 // Установили поддержку до 3 строк (можно поставить 0 для неограниченного)
        return label
    }()
    
    // Вертикальный стек для заголовка и сабтайтла
    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()
    
    // Горизонтальный стек для картинки и текстового блока
    private let headerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .top
        return stack
    }()
    
    private lazy var factsButton: MenuOptionButton = {
        let btn = MenuOptionButton(title: "Interesting Facts", subtitle: "Deep dive into \(itemTitle) history & lore", iconName: "sparkles", color: AppColors.tint)
        btn.addTarget(self, action: #selector(didTapFacts), for: .touchUpInside)
        return btn
    }()
    
    private lazy var quizButton: MenuOptionButton = {
        let btn = MenuOptionButton(title: "Quiz / Test", subtitle: "Test your knowledge on \(itemTitle)", iconName: "questionmark.circle", color: AppColors.link)
        btn.addTarget(self, action: #selector(didTapQuiz), for: .touchUpInside)
        return btn
    }()
    
    private lazy var miniGameButton: MenuOptionButton = {
        let btn = MenuOptionButton(title: "Mini-Game", subtitle: "Manage styling challenge for \(itemTitle)", iconName: "gamecontroller", color: AppColors.onlineIndicator)
        btn.addTarget(self, action: #selector(didTapMiniGame), for: .touchUpInside)
        return btn
    }()
    
    init(itemTitle: String, imageName: String) {
        self.itemTitle = itemTitle
        self.imageName = imageName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.background
        title = "Agency Hub"
        
        headerImageView.image = UIImage(named: imageName)
        titleLabel.text = itemTitle
        
        // Собираем стеки
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(subtitleLabel)
        
        headerStackView.addArrangedSubview(headerImageView)
        headerStackView.addArrangedSubview(textStackView)
        
        [headerStackView, factsButton, quizButton, miniGameButton].forEach {
            view.addSubview($0)
        }
        
        headerImageView.snp.makeConstraints { make in
            make.width.height.equalTo(72)
        }
        
        headerStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        factsButton.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom).offset(28)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(80)
        }
        
        quizButton.snp.makeConstraints { make in
            make.top.equalTo(factsButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(80)
        }
        
        miniGameButton.snp.makeConstraints { make in
            make.top.equalTo(quizButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(80)
        }
    }
    
    @objc private func didTapFacts() {
        let factVC = InterestingFactVC(itemTitle: itemTitle, imageName: imageName)
        navigationController?.pushViewController(factVC, animated: true)
    }
    
    @objc private func didTapQuiz() {
        let quizVC = QuizVC(itemTitle: itemTitle)
        navigationController?.pushViewController(quizVC, animated: true)
    }
    
    @objc private func didTapMiniGame() {
        let miniGVC = MiniGVC()
        navigationController?.pushViewController(miniGVC, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

private final class MenuOptionButton: UIButton {
    private let titleLabelCustom: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = AppColors.textPrimary
        return label
    }()
    
    private let subtitleLabelCustom: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = AppColors.textSecondary
        return label
    }()
    
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    init(title: String, subtitle: String, iconName: String, color: UIColor) {
        super.init(frame: .zero)
        setupButton(title: title, subtitle: subtitle, iconName: iconName, color: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(title: String, subtitle: String, iconName: String, color: UIColor) {
        backgroundColor = AppColors.surface
        layer.cornerRadius = 16
        clipsToBounds = true
        
        titleLabelCustom.text = title
        subtitleLabelCustom.text = subtitle
        iconView.image = UIImage(systemName: iconName)
        iconView.tintColor = color
        
        [titleLabelCustom, subtitleLabelCustom, iconView].forEach { addSubview($0) }
        
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(32)
        }
        
        titleLabelCustom.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.leading.equalTo(iconView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(20)
        }
        
        subtitleLabelCustom.snp.makeConstraints { make in
            make.top.equalTo(titleLabelCustom.snp.bottom).offset(4)
            make.leading.equalTo(iconView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(20)
        }
    }
}
