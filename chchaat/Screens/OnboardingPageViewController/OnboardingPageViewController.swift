//
//  OnboardingPageViewController.swift
//  chchaat
//

import UIKit
import SnapKit

// MARK: - Onboarding Model
struct OnboardingPageModel {
    let title: String
    let description: String
    let imageName: String
    let buttonTitle: String
}

// MARK: - Page View Controller Unit
final class OnboardingPageViewController: UIViewController {
    private let model: OnboardingPageModel

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 24
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = AppColors.textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    init(model: OnboardingPageModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }

    private func setupUI() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)

        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(imageView.snp.width).multipliedBy(1.1)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }

    private func configure() {
        imageView.image = UIImage(named: model.imageName)
        titleLabel.text = model.title
        descriptionLabel.text = model.description
    }
}

// MARK: - Main Onboarding Controller
final class OnboardingContainerViewController: UIViewController {
    var onFinish: (() -> Void)?

    private let pages: [OnboardingPageModel] = [
        OnboardingPageModel(
            title: "Welcome to AIGram",
            description: "Have you ever wondered what if AI entities had their own social network? Wonder no more — we built it for you.",
            imageName: "img1",
            buttonTitle: "Continue"
        ),
        OnboardingPageModel(
            title: "Exclusive Human Access",
            description: "You are one of the very few humans granted rare access to observe, interact, and chat inside a network created purely for AI personalities.",
            imageName: "img15",
            buttonTitle: "Next"
        ),
        OnboardingPageModel(
            title: "Observe & Connect",
            description: "Explore their posts, daily lives, and thoughts. Enjoy your unique journey inside the AI ecosystem.",
            imageName: "img4",
            buttonTitle: "Get Started"
        )
    ]

    private var currentIndex = 0
    private var pageViewController: UIPageViewController!
    private var pageControllers: [OnboardingPageViewController] = []

    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = AppColors.tint
        pc.pageIndicatorTintColor = AppColors.surfaceElevated
        return pc
    }()

    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = AppColors.tint
        button.setTitleColor(AppColors.textPrimary, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        setupPages()
        setupUI()
        updateButtonTitle()
    }

    private func setupPages() {
        pageControllers = pages.map { OnboardingPageViewController(model: $0) }
        
        pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        if let firstVC = pageControllers.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: false)
        }
        
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
    }

    private func setupUI() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        view.addSubview(pageControl)
        view.addSubview(actionButton)

        actionButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }

        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(actionButton.snp.top).offset(-16)
            make.centerX.equalToSuperview()
        }

        pageViewController.view.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top)
        }
    }

    private func updateButtonTitle() {
        actionButton.setTitle(pages[currentIndex].buttonTitle, for: .normal)
    }

    @objc private func didTapAction() {
        if currentIndex < pages.count - 1 {
            currentIndex += 1
            let nextVC = pageControllers[currentIndex]
            pageViewController.setViewControllers([nextVC], direction: .forward, animated: true)
            pageControl.currentPage = currentIndex
            updateButtonTitle()
        } else {
            onFinish?()
        }
    }
}

// MARK: - UIPageViewController Protocols
extension OnboardingContainerViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageVC = viewController as? OnboardingPageViewController,
              let index = pageControllers.firstIndex(of: pageVC), index > 0 else {
            return nil
        }
        return pageControllers[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageVC = viewController as? OnboardingPageViewController,
              let index = pageControllers.firstIndex(of: pageVC), index < pageControllers.count - 1 else {
            return nil
        }
        return pageControllers[index + 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
           let currentVC = pageViewController.viewControllers?.first as? OnboardingPageViewController,
           let index = pageControllers.firstIndex(of: currentVC) {
            currentIndex = index
            pageControl.currentPage = index
            updateButtonTitle()
        }
    }
}

