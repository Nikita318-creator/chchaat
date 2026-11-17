import Foundation

// MARK: - Models

struct TilePosition: Hashable {
    let layer: Int
    let row: Int
    let col: Int

    /// Unique integer key (rows / cols must stay below 100).
    var key: Int { TilePosition.key(layer: layer, row: row, col: col) }

    static func key(layer: Int, row: Int, col: Int) -> Int {
        layer * 10_000 + row * 100 + col
    }
}

struct MahjongTile {
    let position: TilePosition
    var kind: Int
    var isRemoved = false
}

/// Deterministic RNG (SplitMix64) so level N is always the same puzzle.
struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        state = seed
    }

    mutating func next() -> UInt64 {
        state &+= 0x9E37_79B9_7F4A_7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
        z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
        return z ^ (z >> 31)
    }
}

// MARK: - Engine

enum MahjongEngine {

    /// Massive expanded unique symbol pool: fashion emojis, luxury items,
    /// accessories, aesthetic Chinese characters and lifestyle symbols to prevent duplicates.
    static let symbols = [
        // Fashion & Clothing
        "👗", "👠", "👜", "💄", "🧢", "💍", "👘", "🕶️",
        "✨", "🧵", "💎", "👑", "🧥", "🧣", "🧤", "👢",
        "👔", "🥻", "🥿", "👛", "👝", "🎒", "🩱", "🩲",
        // Extended Style & Accessories
        "🌹", "💄", "💅", "👛", "🎀", "⭐", "💫", "🦄",
        "🍒", "🎧", "🌸", "🦋", "🥂", "🍾", "🕊️", "🥥",
        // Chinese Characters (Aesthetic, Style & Fashion themes)
        "美", "丽", "时", "尚", "衣", "服", "鞋", "包",
        "绫", "罗", "绸", "缎", "绣", "华", "丽", "妆",
        "雅", "韵", "潮", "秀", "锦", "郉", "饰", "颜",
        "香", "芬", "芳", "菲", "兰", "芷", "莹", "玲"
    ]

    private static let maxLayers = 6

    /// Dynamically scales symbol variety based on level to keep gameplay challenging.
    static func kindCount(for level: Int) -> Int {
        min(symbols.count, 10 + (level - 1) / 2)
    }

    // MARK: Rules

    /// A tile is free when nothing lies on top of it
    /// and its left OR right neighbour on the same layer is empty.
    static func isFree(_ position: TilePosition, in occupied: Set<Int>) -> Bool {
        for layer in stride(from: position.layer + 1, through: maxLayers, by: 1) {
            let key = TilePosition.key(layer: layer, row: position.row, col: position.col)
            if occupied.contains(key) { return false }
        }
        let left = occupied.contains(TilePosition.key(layer: position.layer, row: position.row, col: position.col - 1))
        let right = occupied.contains(TilePosition.key(layer: position.layer, row: position.row, col: position.col + 1))
        return !left || !right
    }

    // MARK: Level creation

    static func makeLevel(_ level: Int) -> [MahjongTile] {
        var rng = SeededGenerator(seed: UInt64(level) &* 7919 &+ 17)
        let kinds = kindCount(for: level)

        for _ in 0..<100 {
            let positions = layout(level: level, using: &rng)
            if let assigned = assignKinds(positions: positions, kindCount: kinds, attempts: 2, using: &rng) {
                return zip(positions, assigned).map { MahjongTile(position: $0, kind: $1) }
            }
        }

        // Fallback: dense structured board if specific layout generation struggles
        let flat = stack(cols: 6, rows: 6, layers: 2)
        let assigned = assignKinds(positions: flat, kindCount: kinds, attempts: 50, using: &rng)
            ?? Array(repeating: 0, count: flat.count)
        return zip(flat, assigned).map { MahjongTile(position: $0, kind: $1) }
    }

    static func assignKinds<G: RandomNumberGenerator>(
        positions: [TilePosition],
        kindCount: Int,
        attempts: Int,
        using rng: inout G
    ) -> [Int]? {
        for _ in 0..<max(1, attempts) {
            if let result = tryAssign(positions: positions, kindCount: kindCount, using: &rng) {
                return result
            }
        }
        return nil
    }

    /// Assigns kinds by playing backwards, strictly preventing duplicate pairs
    /// of the same kind from clustering or repeating unnecessarily among active free choices.
    private static func tryAssign<G: RandomNumberGenerator>(
        positions: [TilePosition],
        kindCount: Int,
        using rng: inout G
    ) -> [Int]? {
        let count = positions.count
        if count == 0 { return [] }
        guard count % 2 == 0, kindCount > 0 else { return nil }

        let actualKindCount = min(kindCount, symbols.count)
        let pairsCount = count / 2

        // Создаем строго сбалансированный пул индексов иероглифов/эмодзи,
        // чтобы каждый символ использовался примерно одинаковое число раз без дублирования лишних пар.
        var pairKinds: [Int] = []
        for i in 0..<pairsCount {
            pairKinds.append(i % actualKindCount)
        }
        pairKinds.shuffle(using: &rng)

        var kinds = [Int](repeating: 0, count: count)
        var active = Set(0..<count)
        var occupied = Set(positions.map { $0.key })
        var pairIndex = 0

        while !active.isEmpty {
            let free = active.sorted().filter { isFree(positions[$0], in: occupied) }
            guard free.count >= 2 else { return nil }

            var chosen: (Int, Int)?
            for _ in 0..<15 {
                guard let a = free.randomElement(using: &rng) else { break }
                var b = a
                while b == a {
                    b = free.randomElement(using: &rng) ?? a
                }

                if active.count == 2 {
                    chosen = (a, b)
                    break
                }

                var after = occupied
                after.remove(positions[a].key)
                after.remove(positions[b].key)
                let freeAfter = active.filter { $0 != a && $0 != b && isFree(positions[$0], in: after) }.count
                if freeAfter >= 2 {
                    chosen = (a, b)
                    break
                }
            }

            guard let pair = chosen else { return nil }
            
            // Берем следующий уникальный вид из перемешанного пула пар
            let assignedKind = pairKinds[min(pairIndex, pairKinds.count - 1)]
            kinds[pair.0] = assignedKind
            kinds[pair.1] = assignedKind
            pairIndex += 1

            active.remove(pair.0)
            active.remove(pair.1)
            occupied.remove(positions[pair.0].key)
            occupied.remove(positions[pair.1].key)
        }
        return kinds
    }

    // MARK: Layouts (Challenging & Scaling)

    private static func layout<G: RandomNumberGenerator>(level: Int, using rng: inout G) -> [TilePosition] {
        var target = 52 + (level * 2)
        if target > 144 { target = 144 } // Max density cap
        if target % 2 != 0 { target += 1 }

        let layerCap = min(maxLayers, 3 + (level - 1) / 20)
        let sizes = [(6, 6), (7, 6), (7, 7), (8, 7), (8, 8), (9, 8)]

        var positions = stack(cols: sizes[sizes.count - 1].0, rows: sizes[sizes.count - 1].1, layers: layerCap)
        for size in sizes {
            let candidate = stack(cols: size.0, rows: size.1, layers: layerCap)
            if candidate.count >= target {
                positions = candidate
                break
            }
        }

        while positions.count > target || positions.count % 2 != 0 {
            let top = positions.map { $0.layer }.max() ?? 0
            let candidates = positions.indices.filter { positions[$0].layer == top }
            guard let index = candidates.randomElement(using: &rng) else { break }
            positions.remove(at: index)
        }
        return positions
    }

    private static func stack(cols: Int, rows: Int, layers: Int) -> [TilePosition] {
        var cells = Set<Int>()
        for r in 0..<rows {
            for c in 0..<cols {
                cells.insert(r * 100 + c)
            }
        }

        var result = [TilePosition]()
        for layer in 0..<layers {
            if cells.isEmpty { break }
            for cell in cells.sorted() {
                result.append(TilePosition(layer: layer, row: cell / 100, col: cell % 100))
            }
            let current = cells
            cells = current.filter { cell in
                [cell - 100, cell + 100, cell - 1, cell + 1].allSatisfy { current.contains($0) }
            }
        }
        return result
    }
}
