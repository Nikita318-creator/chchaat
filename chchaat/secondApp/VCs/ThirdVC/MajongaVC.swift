//
//  MajongaVC.swift
//  chchaat
//
//  Fashion mahjong game screen (replaces MiniGVC).
//

import UIKit
import SnapKit

// MARK: - Tile view

final class MahjongTileView: UIView {

    enum State {
        case free, blocked, selected, hinted
    }

    private let depthView = UIView()
    private let faceView = UIView()
    private let symbolLabel = UILabel()

    init(symbol: String, tileSize: CGSize, depth: CGFloat) {
        super.init(frame: CGRect(origin: .zero, size: tileSize))
        let radius = tileSize.width * 0.18

        // "Thickness" of the tile, drawn behind the face
        depthView.frame = CGRect(x: depth * 0.5, y: depth, width: tileSize.width, height: tileSize.height)
        depthView.layer.cornerRadius = radius
        depthView.layer.shadowColor = AppColors.background.cgColor
        depthView.layer.shadowOpacity = 0.7
        depthView.layer.shadowOffset = CGSize(width: 1, height: 3)
        depthView.layer.shadowRadius = 3
        depthView.layer.shadowPath = UIBezierPath(
            roundedRect: CGRect(origin: .zero, size: tileSize),
            cornerRadius: radius
        ).cgPath

        faceView.frame = bounds
        faceView.layer.cornerRadius = radius

        symbolLabel.frame = bounds
        symbolLabel.text = symbol
        symbolLabel.textAlignment = .center
        symbolLabel.font = .systemFont(ofSize: tileSize.width * 0.52)

        addSubview(depthView)
        addSubview(faceView)
        faceView.addSubview(symbolLabel)

        setState(.blocked, animated: false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setSymbol(_ symbol: String) {
        symbolLabel.text = symbol
    }

    func setState(_ state: State, animated: Bool) {
        let faceColor: UIColor
        let depthColor: UIColor
        let borderColor: UIColor
        let borderWidth: CGFloat
        let labelAlpha: CGFloat
        let scale: CGFloat

        switch state {
        case .free:
            faceColor = AppColors.textPrimary
            depthColor = AppColors.tint
            borderColor = AppColors.tintSecondary
            borderWidth = 1.5
            labelAlpha = 1
            scale = 1
        case .blocked:
            faceColor = AppColors.surface
            depthColor = AppColors.separator
            borderColor = AppColors.textMuted.withAlphaComponent(0.35)
            borderWidth = 1
            labelAlpha = 0.3
            scale = 1
        case .selected:
            faceColor = AppColors.tintSecondary
            depthColor = AppColors.tint
            borderColor = AppColors.link
            borderWidth = 3
            labelAlpha = 1
            scale = 1.08
        case .hinted:
            faceColor = AppColors.textPrimary
            depthColor = AppColors.tint
            borderColor = AppColors.link
            borderWidth = 3
            labelAlpha = 1
            scale = 1.04
        }

        faceView.layer.borderColor = borderColor.cgColor
        faceView.layer.borderWidth = borderWidth

        let changes = {
            self.faceView.backgroundColor = faceColor
            self.depthView.backgroundColor = depthColor
            self.symbolLabel.alpha = labelAlpha
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        if animated {
            UIView.animate(withDuration: 0.15, animations: changes)
        } else {
            changes()
        }
    }

    func animateRemoval() {
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: { _ in
            self.isHidden = true
        })
    }

    func flip() {
        UIView.transition(with: self, duration: 0.35, options: .transitionFlipFromLeft, animations: nil)
    }
}

// MARK: - Level complete overlay

private final class LevelCompleteView: UIView {

    var onNext: (() -> Void)?
    var onLevels: (() -> Void)?

    private let card = UIView()

    init(level: Int, isLastLevel: Bool) {
        super.init(frame: .zero)
        backgroundColor = AppColors.background.withAlphaComponent(0.88)

        card.backgroundColor = AppColors.surface
        card.layer.cornerRadius = 28
        card.layer.borderWidth = 1
        card.layer.borderColor = AppColors.separator.cgColor
        addSubview(card)

        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = AppColors.surfaceElevated
        if let image = AppAssets.victoryImage(for: level) {
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
        } else {
            imageView.image = UIImage(systemName: "sparkles")
            imageView.tintColor = AppColors.tintSecondary
            imageView.contentMode = .center
        }

        let titleLabel = UILabel()
        titleLabel.text = isLastLevel ? "The Realm Is Saved!" : "Look Restored!"
        titleLabel.font = .systemFont(ofSize: 26, weight: .bold)
        titleLabel.textColor = AppColors.textPrimary
        titleLabel.textAlignment = .center

        let subtitleLabel = UILabel()
        subtitleLabel.text = isLastLevel
            ? "All 100 looks are restored. You are the greatest stylist the Fashion Realm has ever seen."
            : "Level \(level) complete. The Fashion Realm shines a little brighter."
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .regular)
        subtitleLabel.textColor = AppColors.textSecondary
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0

        let nextButton = GradientButton()
        nextButton.setTitle("Next Level", for: .normal)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)

        let levelsButton = UIButton(type: .custom)
        levelsButton.setTitle("Back to Levels", for: .normal)
        levelsButton.applySecondaryStyle()
        levelsButton.addTarget(self, action: #selector(didTapLevels), for: .touchUpInside)

        var arranged: [UIView] = [imageView, titleLabel, subtitleLabel]
        if !isLastLevel { arranged.append(nextButton) }
        arranged.append(levelsButton)

        let stack = UIStackView(arrangedSubviews: arranged)
        stack.axis = .vertical
        stack.spacing = 14
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stack.setCustomSpacing(8, after: titleLabel)
        stack.setCustomSpacing(20, after: subtitleLabel)
        card.addSubview(stack)

        card.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(28)
        }
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.height.equalTo(190)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
        levelsButton.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func animateIn() {
        alpha = 0
        card.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: []) {
            self.alpha = 1
            self.card.transform = .identity
        }
    }

    @objc private func didTapNext() { onNext?() }
    @objc private func didTapLevels() { onLevels?() }
}

// MARK: - Game screen

final class MajongaVC: UIViewController {

    // MARK: State
    private var level: Int
    private let store = ProgressStore.shared

    private var tiles: [MahjongTile] = []
    private var tileViews: [MahjongTileView] = []
    private var selectedIndex: Int?
    private var hintedIndices: Set<Int> = []
    private var hintWorkItem: DispatchWorkItem?
    private var isLevelFinished = false
    private var builtForWidth: CGFloat = 0
    private var completeOverlay: LevelCompleteView?
    private var backgroundGradient: CAGradientLayer?

    // MARK: UI
    private let headerCard: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.surface
        view.layer.cornerRadius = 18
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColors.separator.cgColor
        return view
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = AppColors.textPrimary
        button.backgroundColor = AppColors.surfaceElevated
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .center
        return label
    }()

    private let statsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = AppColors.textSecondary
        label.textAlignment = .center
        return label
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private let boardContainer = UIView()

    private lazy var hintButton = makeToolButton(title: "Hint", symbol: "lightbulb.fill", action: #selector(didTapHint))
    private lazy var shuffleButton = makeToolButton(title: "Shuffle", symbol: "shuffle", action: #selector(didTapShuffle))
    private lazy var restartButton = makeToolButton(title: "Restart", symbol: "arrow.counterclockwise", action: #selector(didTapRestart))

    // MARK: Init
    init(level: Int) {
        self.level = min(max(1, level), ProgressStore.totalLevels)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        let gradient = AppGradients.chatBackground(for: view.bounds)
        view.layer.insertSublayer(gradient, at: 0)
        backgroundGradient = gradient

        setupUI()
        startLevel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient?.frame = view.bounds
        let width = scrollView.bounds.width
        if width > 0, abs(width - builtForWidth) > 0.5 {
            buildBoard()
        }
    }

    // MARK: Setup
    private func setupUI() {
        view.addSubview(headerCard)
        headerCard.addSubview(backButton)
        headerCard.addSubview(titleLabel)
        headerCard.addSubview(statsLabel)

        view.addSubview(scrollView)
        scrollView.addSubview(boardContainer)

        let toolbar = UIStackView(arrangedSubviews: [hintButton, shuffleButton, restartButton])
        toolbar.axis = .horizontal
        toolbar.spacing = 10
        toolbar.distribution = .fillEqually
        view.addSubview(toolbar)

        headerCard.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(64)
        }
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.centerY.equalToSuperview()
            make.size.equalTo(36)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.trailing.equalToSuperview().inset(60)
        }
        statsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview().inset(60)
        }
        toolbar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
            make.height.equalTo(52)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerCard.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(toolbar.snp.top).offset(-12)
        }
        boardContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(1)
            make.height.equalTo(1)
        }
    }

    private func makeToolButton(title: String, symbol: String, action: Selector) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = UIImage(systemName: symbol)
        config.imagePadding = 6
        config.baseBackgroundColor = AppColors.surface
        config.baseForegroundColor = AppColors.textPrimary
        config.cornerStyle = .large
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = AppColors.separator.cgColor
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    // MARK: Level flow
    private func startLevel() {
        completeOverlay?.removeFromSuperview()
        completeOverlay = nil
        isLevelFinished = false
        selectedIndex = nil
        hintWorkItem?.cancel()
        hintedIndices = []

        tiles = MahjongEngine.makeLevel(level)
        scrollView.setContentOffset(.zero, animated: false)
        buildBoard()
        updateStats()
    }

    private func buildBoard() {
        tileViews.forEach { $0.removeFromSuperview() }
        tileViews.removeAll()
        hintedIndices = []

        let viewport = scrollView.bounds.size
        guard viewport.width > 0, !tiles.isEmpty else { return }
        builtForWidth = viewport.width

        let positions = tiles.map { $0.position }
        let minCol = positions.map { $0.col }.min() ?? 0
        let maxCol = positions.map { $0.col }.max() ?? 0
        let minRow = positions.map { $0.row }.min() ?? 0
        let maxRow = positions.map { $0.row }.max() ?? 0
        let maxLayer = positions.map { $0.layer }.max() ?? 0
        let colSpan = CGFloat(maxCol - minCol + 1)
        let rowSpan = CGFloat(maxRow - minRow + 1)

        let depth: CGFloat = 5
        let layerShift: CGFloat = 5
        let gap: CGFloat = 2
        let padding: CGFloat = 16
        let layerExtra = CGFloat(maxLayer) * layerShift

        let usableWidth = viewport.width - padding * 2 - layerExtra - depth
        let tileWidth = min(56, floor((usableWidth - gap * (colSpan - 1)) / colSpan))
        let tileHeight = floor(tileWidth * 1.3)
        let stepX = tileWidth + gap
        let stepY = tileHeight + gap + 2

        let boardWidth = padding * 2 + layerExtra + depth + (colSpan - 1) * stepX + tileWidth
        let boardHeight = padding * 2 + layerExtra + depth + (rowSpan - 1) * stepY + tileHeight
        let containerWidth = max(boardWidth, viewport.width)
        let containerHeight = max(boardHeight, viewport.height)
        let originX = (containerWidth - boardWidth) / 2 + padding + layerExtra
        let originY = (containerHeight - boardHeight) / 2 + padding + layerExtra

        boardContainer.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(containerWidth)
            make.height.equalTo(containerHeight)
        }

        // Draw order: lower layers first, then top-to-bottom, left-to-right
        let drawOrder = tiles.indices.sorted { lhs, rhs in
            let a = tiles[lhs].position
            let b = tiles[rhs].position
            if a.layer != b.layer { return a.layer < b.layer }
            if a.row != b.row { return a.row < b.row }
            return a.col < b.col
        }

        var created = [MahjongTileView?](repeating: nil, count: tiles.count)
        for index in drawOrder {
            let tile = tiles[index]
            let tileView = MahjongTileView(
                symbol: MahjongEngine.symbols[tile.kind],
                tileSize: CGSize(width: tileWidth, height: tileHeight),
                depth: depth
            )
            tileView.frame = CGRect(
                x: originX + CGFloat(tile.position.col - minCol) * stepX - CGFloat(tile.position.layer) * layerShift,
                y: originY + CGFloat(tile.position.row - minRow) * stepY - CGFloat(tile.position.layer) * layerShift,
                width: tileWidth,
                height: tileHeight
            )
            tileView.tag = index
            tileView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTile(_:))))
            tileView.isHidden = tile.isRemoved
            boardContainer.addSubview(tileView)
            created[index] = tileView
        }
        tileViews = created.compactMap { $0 }
        refreshStates()
    }

    // MARK: Helpers
    private func occupiedKeys() -> Set<Int> {
        Set(tiles.filter { !$0.isRemoved }.map { $0.position.key })
    }

    private func freeIndices() -> [Int] {
        let occupied = occupiedKeys()
        return tiles.indices.filter { !tiles[$0].isRemoved && MahjongEngine.isFree(tiles[$0].position, in: occupied) }
    }

    private func matchGroups() -> [[Int]] {
        Dictionary(grouping: freeIndices(), by: { tiles[$0].kind })
            .values
            .filter { $0.count >= 2 }
            .map { $0.sorted() }
    }

    private func refreshStates() {
        guard tileViews.count == tiles.count else { return }
        let occupied = occupiedKeys()
        for (index, tile) in tiles.enumerated() where !tile.isRemoved {
            let state: MahjongTileView.State
            if selectedIndex == index {
                state = .selected
            } else if hintedIndices.contains(index) {
                state = .hinted
            } else if MahjongEngine.isFree(tile.position, in: occupied) {
                state = .free
            } else {
                state = .blocked
            }
            tileViews[index].setState(state, animated: true)
        }
    }

    private func updateStats() {
        let remaining = tiles.filter { !$0.isRemoved }.count
        let matches = matchGroups().reduce(0) { $0 + $1.count * ($1.count - 1) / 2 }
        titleLabel.text = "Level \(level)"
        statsLabel.text = "Tiles left: \(remaining)  •  Matches available: \(matches)"
    }

    private func clearHint() {
        hintWorkItem?.cancel()
        if !hintedIndices.isEmpty {
            hintedIndices = []
            refreshStates()
        }
    }

    // MARK: Gameplay
    @objc private func didTapTile(_ gesture: UITapGestureRecognizer) {
        guard !isLevelFinished, let tileView = gesture.view as? MahjongTileView else { return }
        let index = tileView.tag
        guard tiles.indices.contains(index), !tiles[index].isRemoved else { return }

        clearHint()

        guard MahjongEngine.isFree(tiles[index].position, in: occupiedKeys()) else {
            tileView.shake()
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
            return
        }

        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        guard let selected = selectedIndex else {
            selectedIndex = index
            refreshStates()
            return
        }

        if selected == index {
            selectedIndex = nil
            refreshStates()
            return
        }

        if tiles[selected].kind == tiles[index].kind {
            tiles[selected].isRemoved = true
            tiles[index].isRemoved = true
            tileViews[selected].animateRemoval()
            tileViews[index].animateRemoval()
            selectedIndex = nil
            refreshStates()
            updateStats()
            evaluateBoard()
        } else {
            selectedIndex = index
            refreshStates()
        }
    }

    private func evaluateBoard() {
        if tiles.allSatisfy({ $0.isRemoved }) {
            finishLevel()
        } else if matchGroups().isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                self?.presentNoMovesAlert()
            }
        }
    }

    private func finishLevel() {
        isLevelFinished = true
        store.markCompleted(level)
        UINotificationFeedbackGenerator().notificationOccurred(.success)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            guard let self = self else { return }
            let overlay = LevelCompleteView(level: self.level, isLastLevel: self.level >= ProgressStore.totalLevels)
            overlay.onNext = { [weak self] in self?.advanceToNextLevel() }
            overlay.onLevels = { [weak self] in self?.didTapBack() }
            self.view.addSubview(overlay)
            overlay.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            self.view.layoutIfNeeded()
            overlay.animateIn()
            self.completeOverlay = overlay
        }
    }

    private func advanceToNextLevel() {
        guard level < ProgressStore.totalLevels else {
            didTapBack()
            return
        }
        level += 1
        startLevel()
    }

    // MARK: Shuffle / dead ends
    /// Re-deals symbols on the remaining tiles so that the board stays solvable.
    @discardableResult
    private func shuffleRemaining() -> Bool {
        let indices = tiles.indices.filter { !tiles[$0].isRemoved }
        let positions = indices.map { tiles[$0].position }
        var rng = SystemRandomNumberGenerator()

        guard let kinds = MahjongEngine.assignKinds(
            positions: positions,
            kindCount: MahjongEngine.kindCount(for: level),
            attempts: 300,
            using: &rng
        ) else {
            presentUnsolvableAlert()
            return false
        }

        for (offset, index) in indices.enumerated() {
            tiles[index].kind = kinds[offset]
            tileViews[index].setSymbol(MahjongEngine.symbols[kinds[offset]])
            tileViews[index].flip()
        }
        selectedIndex = nil
        hintedIndices = []
        refreshStates()
        updateStats()
        return true
    }

    private func styled(_ alert: UIAlertController) -> UIAlertController {
        alert.overrideUserInterfaceStyle = .dark
        alert.view.tintColor = AppColors.tintSecondary
        return alert
    }

    private func presentNoMovesAlert() {
        guard presentedViewController == nil, !isLevelFinished else { return }
        let alert = UIAlertController(
            title: "No More Matches",
            message: "There are no identical free tiles left. Shuffle the remaining tiles to keep going.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Shuffle", style: .default) { [weak self] _ in
            self?.shuffleRemaining()
        })
        alert.addAction(UIAlertAction(title: "Restart Level", style: .destructive) { [weak self] _ in
            self?.startLevel()
        })
        present(styled(alert), animated: true)
    }

    private func presentUnsolvableAlert() {
        guard presentedViewController == nil, !isLevelFinished else { return }
        let alert = UIAlertController(
            title: "Stuck Stack",
            message: "The remaining tiles are locked in a way that can't be solved. Restart the level to try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Restart Level", style: .default) { [weak self] _ in
            self?.startLevel()
        })
        present(styled(alert), animated: true)
    }

    // MARK: Actions
    @objc private func didTapHint() {
        guard !isLevelFinished else { return }
        clearHint()

        var pair: [Int]?
        if let selected = selectedIndex,
           let partner = freeIndices().first(where: { $0 != selected && tiles[$0].kind == tiles[selected].kind }) {
            pair = [selected, partner]
        } else if let group = matchGroups().first {
            pair = Array(group.prefix(2))
        }

        guard let found = pair else {
            presentNoMovesAlert()
            return
        }

        hintedIndices = Set(found)
        refreshStates()

        let work = DispatchWorkItem { [weak self] in
            self?.hintedIndices = []
            self?.refreshStates()
        }
        hintWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: work)
    }

    @objc private func didTapShuffle() {
        guard !isLevelFinished else { return }
        clearHint()
        shuffleRemaining()
    }

    @objc private func didTapRestart() {
        startLevel()
    }

    @objc private func didTapBack() {
        if let navigationController = navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}
