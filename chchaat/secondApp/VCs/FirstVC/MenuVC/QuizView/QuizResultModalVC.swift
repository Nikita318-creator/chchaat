import UIKit
import SnapKit

final class QuizResultModalVC: UIViewController {
    
    private let score: Int
    private let total: Int
    private let resultItems: [QuizResultItem]
    private let onRestart: () -> Void
    private let onFinish: () -> Void
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.surface
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Quiz Completed!"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .center
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = AppColors.tintSecondary
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.dataSource = self
        tv.register(ResultItemCell.self, forCellReuseIdentifier: ResultItemCell.identifier)
        return tv
    }()
    
    private lazy var restartButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Try Again", for: .normal)
        btn.setTitleColor(AppColors.textPrimary, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.backgroundColor = AppColors.surfaceElevated
        btn.layer.cornerRadius = 14
        btn.addTarget(self, action: #selector(didTapRestart), for: .touchUpInside)
        return btn
    }()
    
    private lazy var finishButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Back to Hub", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.backgroundColor = AppColors.tint
        btn.layer.cornerRadius = 14
        btn.addTarget(self, action: #selector(didTapFinish), for: .touchUpInside)
        return btn
    }()
    
    init(score: Int, total: Int, resultItems: [QuizResultItem], onRestart: @escaping () -> Void, onFinish: @escaping () -> Void) {
        self.score = score
        self.total = total
        self.resultItems = resultItems
        self.onRestart = onRestart
        self.onFinish = onFinish
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        scoreLabel.text = "You scored \(score) out of \(total)"
        
        view.addSubview(containerView)
        [titleLabel, scoreLabel, tableView, restartButton, finishButton].forEach {
            containerView.addSubview($0)
        }
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(view.snp.height).multipliedBy(0.75)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(scoreLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(restartButton.snp.top).offset(-16)
        }
        
        restartButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(24)
            make.height.equalTo(50)
            make.width.equalTo(finishButton)
            make.trailing.equalTo(finishButton.snp.leading).offset(-12)
        }
        
        finishButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(24)
            make.height.equalTo(50)
        }
    }
    
    @objc private func didTapRestart() {
        dismiss(animated: true) {
            self.onRestart()
        }
    }
    
    @objc private func didTapFinish() {
        dismiss(animated: true) {
            self.onFinish()
        }
    }
}

// MARK: - UITableViewDataSource
extension QuizResultModalVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultItemCell.identifier, for: indexPath) as? ResultItemCell else {
            return UITableViewCell()
        }
        cell.configure(with: resultItems[indexPath.row], index: indexPath.row + 1)
        return cell
    }
}

// MARK: - Result Item Cell
private final class ResultItemCell: UITableViewCell {
    static let identifier = "ResultItemCell"
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.surfaceElevated
        view.layer.cornerRadius = 14
        return view
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = AppColors.textSecondary
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.addSubview(cardView)
        [statusLabel, questionLabel, detailsLabel].forEach { cardView.addSubview($0) }
        
        cardView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(6)
            make.horizontalEdges.equalToSuperview()
        }
        
        // Статус теперь располагается на самой верхней строке карточки
        statusLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().inset(12)
        }
        
        // Вопрос идет сразу под статусом и занимает всю ширину
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        detailsLabel.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configure(with item: QuizResultItem, index: Int) {
        questionLabel.text = "\(index). \(item.questionText)"
        
        if item.isCorrect {
            statusLabel.text = "CORRECT"
            statusLabel.textColor = AppColors.onlineIndicator
        } else {
            statusLabel.text = "INCORRECT"
            statusLabel.textColor = AppColors.destructive
        }
        
        if item.isCorrect {
            detailsLabel.text = "Your answer: \(item.selectedAnswer)\n💡 \(item.explanation)"
        } else {
            detailsLabel.text = "Your answer: \(item.selectedAnswer)\nCorrect: \(item.correctAnswer)\n💡 \(item.explanation)"
        }
    }
}
