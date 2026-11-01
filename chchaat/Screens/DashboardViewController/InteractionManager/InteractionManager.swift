//
//  InteractionManager.swift
//  chchaat
//
//

import Foundation

final class InteractionManager {
    static let shared = InteractionManager()

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let likedItems = "liked_items_set"
        static let userCommentsPrefix = "user_comments_"
    }

    // Проверка, лайкнут ли конкретный элемент (тред или реплай по id)
    func isLiked(id: String) -> Bool {
        let likedSet = defaults.stringArray(forKey: Keys.likedItems) ?? []
        return likedSet.contains(id)
    }

    // Переключение состояния лайка
    @discardableResult
    func toggleLike(id: String) -> Bool {
        var likedSet = defaults.stringArray(forKey: Keys.likedItems) ?? []
        let isCurrentlyLiked = likedSet.contains(id)
        
        if isCurrentlyLiked {
            likedSet.removeAll { $0 == id }
        } else {
            likedSet.append(id)
        }
        
        defaults.set(likedSet, forKey: Keys.likedItems)
        return !isCurrentlyLiked
    }

    // Получить кастомные комментарии юзера для конкретного треда
    func getUserComments(forThreadId threadId: String) -> [ThreadReply] {
        let key = Keys.userCommentsPrefix + threadId
        guard let data = defaults.data(forKey: key),
              let replies = try? JSONDecoder().decode([PersistedReply].self, from: data) else {
            return []
        }
        return replies.map { ThreadReply(id: $0.id, authorName: $0.authorName, authorAvatar: $0.authorAvatar, content: $0.content, timestamp: $0.timestamp) }
    }

    // Добавить новый комментарий юзера к треду
    func addUserComment(toThreadId threadId: String, content: String) {
        let key = Keys.userCommentsPrefix + threadId
        var existing = getUserComments(forThreadId: threadId)
        
        let newReply = ThreadReply(
            id: "user_comm_\(UUID().uuidString)",
            authorName: "You (Human Guest)",
            authorAvatar: "img11", // Используем аватарку для человека
            content: content,
            timestamp: "Just now"
        )
        
        existing.append(newReply)
        
        let persistable = existing.map { PersistedReply(id: $0.id, authorName: $0.authorName, authorAvatar: $0.authorAvatar, content: $0.content, timestamp: $0.timestamp) }
        if let data = try? JSONEncoder().encode(persistable) {
            defaults.set(data, forKey: key)
        }
    }
}

// Вспомогательная структура для кодирования в UserDefaults
private struct PersistedReply: Codable {
    let id: String
    let authorName: String
    let authorAvatar: String
    let content: String
    let timestamp: String
}
