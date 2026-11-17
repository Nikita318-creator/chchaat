import UIKit
import SnapKit

final class MiniGVC: UIViewController {
    
    // MARK: - Properties
    private let userDefaultsKey = "current_mahjong_fashion_level"
    
    private var currentLevel: Int {
        get { max(1, UserDefaults.standard.integer(forKey: userDefaultsKey)) }
        set { UserDefaults.standard.set(newValue, forKey: userDefaultsKey) }
    }
    
    private struct MahjongTileModel {
        let id: Int          // ID пары (одинаковый для парных плиток)
        let symbol: String   // Эмодзи или иероглиф
        let layer: Int       // Слой (0 - низ, выше - сложнее)
        let row: Int
        let col: Int
        var isRemoved: Bool = false
        var isSelected: Bool = false
    }
    
    private var tiles: [MahjongTileModel] = []
    private var selectedTileIndex: Int?
    
    // Модная база для маджонга (эмодзи ↔ иероглиф стиля)
    private let fashionTileSymbols = [
        ("👗", "衫"), ("👠", "履"), ("👜", "包"), ("💄", "妆"),
        ("🧢", "帽"), ("💍", "饰"), ("👘", "服"), ("🕶️", "镜"),
        ("✨", "潮"), ("🧵", "绣"), ("💎", "宝"), ("👑", "冠"),
        ("🧥", "衣"), ("🧣", "巾"), ("🧤", "手"), ("👢", "靴")
    ]
    
    // MARK: - UI Components
    private let headerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.surface
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColors.separator.cgColor
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "FASHION MAHJONG SOLITAIRE"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .center
        return label
    }()
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = AppColors.tintSecondary
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
    
    private lazy var resetButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Reset Progress", for: .normal)
        btn.setTitleColor(AppColors.destructive, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        btn.addTarget(self, action: #selector(didTapReset), for: .touchUpInside)
        return btn
    }()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = true
        sv.showsHorizontalScrollIndicator = true
        return sv
    }()
    
    private let boardContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var nextLevelButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Next Mahjong Level ⚡️", for: .normal)
        btn.setTitleColor(AppColors.textPrimary, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        btn.backgroundColor = AppColors.tint
        btn.layer.cornerRadius = 14
        btn.addTarget(self, action: #selector(didTapNextLevel), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupUI()
        setupConstraints()
        generateLevel()
    }
    
    private func setupBackground() {
        view.backgroundColor = AppColors.background
    }
    
    private func setupUI() {
        title = "Style Mahjong"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: AppColors.textPrimary,
            .font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        
        view.addSubview(headerContainer)
        headerContainer.addSubview(titleLabel)
        headerContainer.addSubview(levelLabel)
        headerContainer.addSubview(statsLabel)
        headerContainer.addSubview(resetButton)
        
        view.addSubview(scrollView)
        scrollView.addSubview(boardContainerView)
        
        view.addSubview(nextLevelButton)
        nextLevelButton.isHidden = true
    }
    
    private func setupConstraints() {
        headerContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        levelLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        statsLabel.snp.makeConstraints { make in
            make.top.equalTo(levelLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        resetButton.snp.makeConstraints { make in
            make.top.equalTo(statsLabel.snp.bottom).offset(6)
            make.bottom.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerContainer.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(nextLevelButton.snp.top).offset(-16)
        }
        
        boardContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(420)
            make.height.equalTo(600)
        }
        
        nextLevelButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Mahjong Generation & Layout
    private func generateLevel() {
        levelLabel.text = "LEVEL \(currentLevel) • FASHION SOLITAIRE"
        nextLevelButton.isHidden = true
        selectedTileIndex = nil
        tiles.removeAll()
        
        // Масштабируем сложность от уровня
        let pairsCount = min(12 + (currentLevel - 1) * 3, 28)
        
        // Создаем пул пар (берем и эмодзи, и иероглифы как отдельные парные элементы маджонга)
        var symbolList: [String] = []
        let shuffledPairs = fashionTileSymbols.shuffled()
        
        for i in 0..<pairsCount {
            let pair = shuffledPairs[i % shuffledPairs.count]
            symbolList.append(pair.0)
            symbolList.append(pair.0) // Пара эмодзи
            symbolList.append(pair.1)
            symbolList.append(pair.1) // Пара иероглифов
        }
        symbolList.shuffle()
        
        var symbolIndex = 0
        
        // Построение многослойной структуры (Черепаха / Пирамида маджонга)
        // Слой 0: Основа (сетка 6х6)
        for r in 0..<6 {
            for c in 0..<6 {
                if symbolIndex < symbolList.count {
                    let sym = symbolList[symbolIndex]
                    tiles.append(MahjongTileModel(id: symbolIndex / 2, symbol: sym, layer: 0, row: r, col: c))
                    symbolIndex += 1
                }
            }
        }
        
        // Слой 1: Середина (сетка 4х4 поверх)
        for r in 1..<5 {
            for c in 1..<5 {
                if symbolIndex < symbolList.count {
                    let sym = symbolList[symbolIndex]
                    tiles.append(MahjongTileModel(id: symbolIndex / 2, symbol: sym, layer: 1, row: r, col: c))
                    symbolIndex += 1
                }
            }
        }
        
        // Слой 2: Верхушка (центр 2х2)
        for r in 2..<4 {
            for c in 2..<4 {
                if symbolIndex < symbolList.count {
                    let sym = symbolList[symbolIndex]
                    tiles.append(MahjongTileModel(id: symbolIndex / 2, symbol: sym, layer: 2, row: r, col: c))
                    symbolIndex += 1
                }
            }
        }
        
        // Доскидываем остаток, если есть
        while symbolIndex < symbolList.count {
            let sym = symbolList[symbolIndex]
            tiles.append(MahjongTileModel(id: symbolIndex / 2, symbol: sym, layer: Int.random(in: 0...1), row: Int.random(in: 0...5), col: Int.random(in: 0...5)))
            symbolIndex += 1
        }
        
        renderBoard()
        updateStats()
    }
    
    private func updateStats() {
        let remaining = tiles.filter { !$0.isRemoved }.count
        statsLabel.text = "Tiles Remaining: \(remaining) | Match identical free tiles"
    }
    
    // MARK: - Mahjong Blocking Rules Engine
    private func isTileFree(at index: Int) -> Bool {
        let tile = tiles[index]
        if tile.isRemoved { return false }
        
        // 1. Проверяем, накрыта ли плитка сверху (более высокий слой с пересечением координат)
        let coveredFromAbove = tiles.contains { other in
            !other.isRemoved &&
            other.layer > tile.layer &&
            abs(other.row - tile.row) <= 0 &&
            abs(other.col - tile.col) <= 0
        }
        
        if coveredFromAbove { return false }
        
        // 2. Проверяем боковую блокировку на том же слое (слева И справа должны быть свободны хотя бы с одной стороны)
        let hasLeft = tiles.contains { other in
            !other.isRemoved && other.layer == tile.layer && other.row == tile.row && other.col == tile.col - 1
        }
        
        let hasRight = tiles.contains { other in
            !other.isRemoved && other.layer == tile.layer && other.row == tile.row && other.col == tile.col + 1
        }
        
        // Плитка свободна, если хотя бы один бок (левый или правый) не заблокирован соседом
        return !hasLeft || !hasRight
    }
    
    // MARK: - Rendering
    private func renderBoard() {
        boardContainerView.subviews.forEach { $0.removeFromSuperview() }
        
        let tileWidth: CGFloat = 50
        let tileHeight: CGFloat = 64
        let startX: CGFloat = 20
        let startY: CGFloat = 20
        
        for (index, tile) in tiles.enumerated() {
            guard !tile.isRemoved else { continue }
            
            let isFree = isTileFree(at: index)
            let tileView = createTileView(for: tile, index: index, isFree: isFree)
            
            // Смещение по слоям для 3D глубины маджонга
            let layerOffset = CGFloat(tile.layer) * 6
            let x = startX + CGFloat(tile.col) * 48 + layerOffset
            let y = startY + CGFloat(tile.row) * 56 + layerOffset
            
            boardContainerView.addSubview(tileView)
            tileView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(x)
                make.top.equalToSuperview().offset(y)
                make.width.equalTo(tileWidth)
                make.height.equalTo(tileHeight)
            }
            
            // Сортировка по глубине слоев
            tileView.layer.zPosition = CGFloat(tile.layer * 1000 + tile.row * 10 + tile.col)
        }
    }
    
    private func createTileView(for tile: MahjongTileModel, index: Int, isFree: Bool) -> UIView {
        let container = UIView()
        container.layer.cornerRadius = 8
        
        // Тень маджонг-плитки
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.5
        container.layer.shadowOffset = CGSize(width: 2, height: 3)
        container.layer.shadowRadius = 2
        
        if tile.isSelected {
            container.backgroundColor = AppColors.tint
            container.layer.borderColor = AppColors.tint.cgColor
            container.layer.borderWidth = 2.0
        } else if isFree {
            container.backgroundColor = AppColors.surfaceElevated
            container.layer.borderColor = AppColors.separator.cgColor
            container.layer.borderWidth = 1.5
        } else {
            // Заблокированные плитки темные и неактивные
            container.backgroundColor = AppColors.surface.withAlphaComponent(0.9)
            container.layer.borderColor = AppColors.separator.withAlphaComponent(0.3).cgColor
            container.layer.borderWidth = 1.0
        }
        
        let label = UILabel()
        label.text = tile.symbol
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        label.alpha = isFree ? 1.0 : 0.45
        
        container.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTile(_:)))
        container.tag = index
        container.addGestureRecognizer(tap)
        
        return container
    }
    
    // MARK: - Gameplay Logic
    @objc private func didTapTile(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        let index = view.tag
        
        guard isTileFree(at: index) else {
            shakeView(view)
            return
        }
        
        let clickedTile = tiles[index]
        
        if let selected = selectedTileIndex {
            if selected == index {
                // Снимаем выбор
                tiles[selected].isSelected = false
                selectedTileIndex = nil
                renderBoard()
                return
            }
            
            let firstTile = tiles[selected]
            
            // В маджонге пары ищутся по абсолютно одинаковому символу
            if firstTile.symbol == clickedTile.symbol {
                tiles[selected].isRemoved = true
                tiles[index].isRemoved = true
                tiles[selected].isSelected = false
                selectedTileIndex = nil
                
                renderBoard()
                updateStats()
                checkWinCondition()
            } else {
                // Переключаем выбор на новую плитку
                tiles[selected].isSelected = false
                tiles[index].isSelected = true
                selectedTileIndex = index
                renderBoard()
            }
        } else {
            tiles[index].isSelected = true
            selectedTileIndex = index
            renderBoard()
        }
    }
    
    private func shakeView(_ view: UIView) {
        let anim = CABasicAnimation(keyPath: "position.x")
        anim.duration = 0.07
        anim.repeatCount = 3
        anim.autoreverses = true
        anim.fromValue = view.center.x - 3
        anim.toValue = view.center.x + 3
        view.layer.add(anim, forKey: "shake")
    }
    
    private func checkWinCondition() {
        let remaining = tiles.filter { !$0.isRemoved }.count
        if remaining == 0 {
            nextLevelButton.isHidden = false
            let alert = UIAlertController(
                title: "🀄 Splendid! Level \(currentLevel) Cleared! 🀄",
                message: "You've successfully disassembled the fashion mahjong stack.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Next Level", style: .default, handler: { [weak self] _ in
                self?.didTapNextLevel()
            }))
            present(alert, animated: true)
        }
    }
    
    @objc private func didTapReset() {
        currentLevel = 1
        generateLevel()
    }
    
    @objc private func didTapNextLevel() {
        currentLevel += 1
        generateLevel()
    }
}
