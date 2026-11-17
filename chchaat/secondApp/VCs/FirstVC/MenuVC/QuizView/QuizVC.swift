import UIKit
import SnapKit

final class QuizVC: UIViewController {
    
    private let viewModel: QuizViewModel
    private var isAnswerLocked = false
    
    private let progressBar: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: .bar)
        pv.trackTintColor = AppColors.surfaceElevated
        pv.progressTintColor = AppColors.tint
        return pv
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = AppColors.textSecondary
        return label
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var optionsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 12
        sv.distribution = .fillEqually
        return sv
    }()
    
    private lazy var nextButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Next Question", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.backgroundColor = AppColors.tint
        btn.layer.cornerRadius = 16
        btn.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        return btn
    }()
    
    init(itemTitle: String) {
        self.viewModel = QuizViewModel(itemTitle: itemTitle)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateContent()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.background
        title = viewModel.itemTitle
        
        [progressBar, progressLabel, questionLabel, optionsStackView, nextButton].forEach {
            view.addSubview($0)
        }
        
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(6)
        }
        
        progressLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(progressLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        optionsStackView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
    }
    
    private func updateContent() {
        guard let question = viewModel.currentQuestion() else { return }
        
        isAnswerLocked = false
        progressLabel.text = viewModel.progressText.uppercased()
        progressBar.setProgress(viewModel.progressValue, animated: true)
        questionLabel.text = question.text
        
        optionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, optionText) in question.options.enumerated() {
            let optionButton = QuizOptionButton(title: optionText, index: index)
            optionButton.addTarget(self, action: #selector(didSelectOption(_:)), for: .touchUpInside)
            
            // Если на этот вопрос уже отвечали ранее (например, при возврате), восстановим состояние проверки
            if let selectedOpt = viewModel.selectedAnswerForCurrent() {
                isAnswerLocked = true
                if index == question.correctIndex {
                    optionButton.setEvaluationState(isCorrect: true, isSelected: selectedOpt == index)
                } else if index == selectedOpt {
                    optionButton.setEvaluationState(isCorrect: false, isSelected: true)
                }
            }
            
            optionsStackView.addArrangedSubview(optionButton)
        }
        
        let isLast = viewModel.currentIndex == viewModel.questions.count - 1
        nextButton.setTitle(isLast ? "Finish Quiz" : "Next Question", for: .normal)
    }
    
    @objc private func didSelectOption(_ sender: QuizOptionButton) {
        guard !isAnswerLocked else { return } // Блокируем повторный выбор на этом же вопросе
        isAnswerLocked = true
        
        viewModel.selectAnswer(optionIndex: sender.index)
        guard let question = viewModel.currentQuestion() else { return }
        
        // Проверяем и подсвечиваем все варианты в стеке
        for case let btn as QuizOptionButton in optionsStackView.arrangedSubviews {
            if btn.index == question.correctIndex {
                // Всегда подсвечиваем правильный зеленым
                btn.setEvaluationState(isCorrect: true, isSelected: btn.index == sender.index)
            } else if btn.index == sender.index {
                // Если юзер выбрал неверный — подсвечиваем его красным
                btn.setEvaluationState(isCorrect: false, isSelected: true)
            } else {
                // Остальные делаем блеклыми
                btn.setDisabledState()
            }
        }
    }
    
    @objc private func didTapNext() {
        guard viewModel.selectedAnswerForCurrent() != nil else {
            return // Ждем, пока пользователь выберет ответ
        }
        
        if viewModel.nextQuestion() {
            updateContent()
        } else {
            // Квиз завершен -> показываем кастомную модалку
            let results = viewModel.calculateResults()
            let modal = QuizResultModalVC(
                score: results.score,
                total: results.total,
                resultItems: results.items,
                onRestart: { [weak self] in
                    self?.viewModel.currentIndex = 0
                    self?.viewModel.userAnswers.removeAll()
                    self?.updateContent()
                },
                onFinish: { [weak self] in
                    // Если в стэке есть SecondVC, возвращаем юзера на него, иначе стандартный pop
                    if let secondVC = self?.navigationController?.viewControllers.first(where: { $0 is SecondVC }) {
                        self?.navigationController?.popToViewController(secondVC, animated: true)
                    } else {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            )
            present(modal, animated: true)
        }
    }
}

// MARK: - Option Button Component
private final class QuizOptionButton: UIButton {
    let index: Int
    
    private let titleCustomLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = AppColors.textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    init(title: String, index: Int) {
        self.index = index
        super.init(frame: .zero)
        setupButton(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(title: String) {
        backgroundColor = AppColors.surface
        layer.cornerRadius = 14
        layer.borderWidth = 1.5
        layer.borderColor = AppColors.separator.cgColor
        clipsToBounds = true
        
        titleCustomLabel.text = title
        addSubview(titleCustomLabel)
        
        titleCustomLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    // Подсветка при выборе (Правильно / Неправильно)
    func setEvaluationState(isCorrect: Bool, isSelected: Bool) {
        if isCorrect {
            backgroundColor = AppColors.onlineIndicator.withAlphaComponent(0.15)
            layer.borderColor = AppColors.onlineIndicator.cgColor
            titleCustomLabel.textColor = AppColors.onlineIndicator
        } else {
            backgroundColor = AppColors.destructive.withAlphaComponent(0.15)
            layer.borderColor = AppColors.destructive.cgColor
            titleCustomLabel.textColor = AppColors.destructive
        }
    }
    
    // Затемнение остальных вариантов, когда ответ уже дан
    func setDisabledState() {
        backgroundColor = AppColors.surface
        layer.borderColor = AppColors.separator.cgColor
        titleCustomLabel.textColor = AppColors.textMuted
    }
}
