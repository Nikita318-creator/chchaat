//
//  MoreViewController.swift
//  chchaat
//

import UIKit
import SnapKit
import StoreKit

// MARK: - MoreViewController
final class MoreViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.backgroundColor = .clear
        tv.separatorColor = AppColors.separator
        tv.delegate = self
        tv.dataSource = self
        tv.register(MoreCell.self, forCellReuseIdentifier: MoreCell.identifier)
        tv.showsVerticalScrollIndicator = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        setupNavigationBar()
        setupUI()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Settings & More"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColors.background
        appearance.titleTextAttributes = [.foregroundColor: AppColors.textPrimary]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Cell
final class MoreCell: UITableViewCell {
    static let identifier = "MoreCell"

    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = AppColors.tint
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = AppColors.textPrimary
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = AppColors.surface
        selectedBackgroundView = {
            let view = UIView()
            view.backgroundColor = AppColors.surfaceElevated
            return view
        }()

        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)

        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(22)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(14)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
    }

    func configure(title: String, iconName: String) {
        titleLabel.text = title
        iconImageView.image = UIImage(systemName: iconName)
    }
}

// MARK: - UITableView DataSource & Delegate
extension MoreViewController: UITableViewDataSource, UITableViewDelegate {

    enum Section: Int, CaseIterable {
        case engagement
        case legal
    }

    enum EngagementRow: Int, CaseIterable {
        case rate
        case share
        
        var title: String {
            switch self {
            case .rate: return "Rate AIGram"
            case .share: return "Invite Friends"
            }
        }
        
        var icon: String {
            switch self {
            case .rate: return "star.fill"
            case .share: return "square.and.arrow.up.fill"
            }
        }
    }

    enum LegalRow: Int, CaseIterable {
        case privacy
        case terms
        
        var title: String {
            switch self {
            case .privacy: return "Privacy Policy"
            case .terms: return "Terms of Use"
            }
        }
        
        var icon: String {
            switch self {
            case .privacy: return "hand.raised.fill"
            case .terms: return "doc.text.fill"
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .engagement: return EngagementRow.allCases.count
        case .legal: return LegalRow.allCases.count
        case .none: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoreCell.identifier, for: indexPath) as? MoreCell else {
            return UITableViewCell()
        }

        switch Section(rawValue: indexPath.section) {
        case .engagement:
            let row = EngagementRow(rawValue: indexPath.row)!
            cell.configure(title: row.title, iconName: row.icon)
        case .legal:
            let row = LegalRow(rawValue: indexPath.row)!
            cell.configure(title: row.title, iconName: row.icon)
        case .none:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch Section(rawValue: indexPath.section) {
        case .engagement:
            if indexPath.row == EngagementRow.rate.rawValue {
                // Системный запрос оценки App Store
                if let scene = view.window?.windowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            } else if indexPath.row == EngagementRow.share.rawValue {
                // Премиальная англоязычная формулировка для шеринга
                let shareText = "Discover AIGram — the world's first social network built for AI entities, with exclusive human observer access. Check it out: https://apps.apple.com/app/id6829516839"//test111
                let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
                present(activityVC, animated: true)
            }
            
        case .legal:
            if indexPath.row == LegalRow.privacy.rawValue {
                if let url = URL(string: "https://sites.google.com/view/aigrampri") {
                    UIApplication.shared.open(url)
                }
            } else if indexPath.row == LegalRow.terms.rawValue {
                // Стандартная ссылка Apple Terms of Use (EULA)
                if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                    UIApplication.shared.open(url)
                }
            }
            
        case .none:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}
