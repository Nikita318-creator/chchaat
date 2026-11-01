//
//  ChatViewModel.swift
//  chchaat
//

import Foundation

@MainActor
final class ChatViewModel {
    let character: AICharacter
    private(set) var messages: [MessageModel] = []

    // UI Callbacks
    var onStateChanged: (() -> Void)?
    var onMessageAppended: ((Int) -> Void)?

    // Счётчик запросов в полёте: индикатор не гаснет, пока ждём хотя бы один ответ
    private var pendingRequests = 0 {
        didSet { onStateChanged?() }
    }
    var isTyping: Bool { pendingRequests > 0 }

    private static let fallbackText =
        "Oh my sweet, something went wrong and I couldn't get your message, could you please write to me again I beg you 💖"

    init(character: AICharacter) {
        self.character = character
        messages = ChatStorageService.shared.fetchMessages(for: character.id)
    }

    func sendMessage(text: String, language: String?) {
        // История берётся ДО добавления нового сообщения
        let prompt = buildHistoryPrompt(language: language, newText: text)

        // 1. Сохраняем сообщение юзера и показываем в UI
        append(text: text, isFromUser: true)

        // 2. Включаем индикатор печати
        pendingRequests += 1

        // 3. Запрос к ИИ
        Task {
            defer { pendingRequests -= 1 }
            do {
                let reply = try await NeuralDispatcher.shared.send(history: prompt)
                append(text: reply, isFromUser: false)
            } catch {
                print("❌ [NeuralDispatcher] Error: \(error)")
                append(text: Self.fallbackText, isFromUser: false)
            }
        }
    }

    private func append(text: String, isFromUser: Bool) {
        let message = ChatStorageService.shared.saveMessage(
            characterId: character.id, text: text, isFromUser: isFromUser
        )
        messages.append(message)
        onMessageAppended?(messages.count - 1)
    }

    private func buildHistoryPrompt(language: String?, newText: String) -> String {
        var parts = ["твой ответ должен быть на языке пользователя который соответствует коду: '\(language ?? "en")'"]

        let last = messages.suffix(8)
        if !last.isEmpty {
            parts.append("I am attaching the history of our correspondence for context")
            for msg in last {
                parts.append("\(msg.isFromUser ? "[user]" : "[AI companion]") \(msg.text)")
            }
        }

        parts.append("And now I'm writing: \(newText)")
        return parts.joined(separator: "\n")
    }
}
