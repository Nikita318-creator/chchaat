//
//  ProgressStore.swift
//  chchaat
//
//  Persists completed levels and the onboarding flag in UserDefaults.
//

import Foundation

final class ProgressStore {

    static let shared = ProgressStore()
    static let totalLevels = 100

    private enum Keys {
        static let completedLevels = "majonga.completedLevels"
        static let onboardingSeen = "majonga.onboardingSeen"
    }

    private let defaults: UserDefaults
    private(set) var completedLevels: Set<Int>

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let saved = defaults.array(forKey: Keys.completedLevels) as? [Int] ?? []
        completedLevels = Set(saved.filter { (1...ProgressStore.totalLevels).contains($0) })
    }

    var completedCount: Int { completedLevels.count }

    /// First level that is not completed yet (or the last level if everything is done).
    var currentLevel: Int {
        var level = 1
        while level < ProgressStore.totalLevels, completedLevels.contains(level) {
            level += 1
        }
        return level
    }

    func isCompleted(_ level: Int) -> Bool {
        completedLevels.contains(level)
    }

    /// Levels unlock one after another.
    func isUnlocked(_ level: Int) -> Bool {
        level >= 1 && level <= currentLevel
    }

    func markCompleted(_ level: Int) {
        guard (1...ProgressStore.totalLevels).contains(level) else { return }
        completedLevels.insert(level)
        defaults.set(completedLevels.sorted(), forKey: Keys.completedLevels)
    }

    var hasSeenOnboarding: Bool {
        get { defaults.bool(forKey: Keys.onboardingSeen) }
        set { defaults.set(newValue, forKey: Keys.onboardingSeen) }
    }
}
