//  ChatViewModel.swift
//  chchaat

import Foundation

@MainActor
final class ChatViewModel {
    let character: AICharacter
    private(set) var messages: [MessageModel] = []

    // UI Callbacks
    var onStateChanged: (() -> Void)?
    var onMessageAppended: ((Int) -> Void)?

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
        let prompt = buildHistoryPrompt(language: language, newText: text)

        // 1. Сохраняем сообщение юзера
        append(text: text, isFromUser: true, isAudioMessage: false, audioLocalPath: nil)

        // 2. Включаем индикатор печати
        pendingRequests += 1

        // 3. Запрос к ИИ
        Task {
            defer { pendingRequests -= 1 }
            do {
                let reply = try await NeuralDispatcher.shared.send(history: prompt)
                
                // Проверяем настройку аудиосообщений
                let isAudioEnabled = UserDefaults.standard.bool(forKey: "audioMessagesEnabled")
                
                if isAudioEnabled {
                    // Конвертируем текст в аудио через TTS сервис
                    TextToSpeechService.shared.synthesizeSpeech(text: reply) { [weak self] result in
                        Task { @MainActor in
                            guard let self = self else { return }
                            switch result {
                            case .success(let audioURL):
                                self.append(
                                    text: reply,
                                    isFromUser: false,
                                    isAudioMessage: true,
                                    audioLocalPath: audioURL.path
                                )
                            case .failure(let error):
                                print("❌ [TTS] Error: \(error)")
                                self.append(text: reply, isFromUser: false, isAudioMessage: false, audioLocalPath: nil)
                            }
                        }
                    }
                } else {
                    append(text: reply, isFromUser: false, isAudioMessage: false, audioLocalPath: nil)
                }
                
            } catch {
                print("❌ [NeuralDispatcher] Error: \(error)")
                append(text: Self.fallbackText, isFromUser: false, isAudioMessage: false, audioLocalPath: nil)
            }
        }
    }

    private func append(text: String, isFromUser: Bool, isAudioMessage: Bool, audioLocalPath: String?) {
        let message = ChatStorageService.shared.saveMessage(
            characterId: character.id,
            text: text,
            isFromUser: isFromUser,
            isAudioMessage: isAudioMessage,
            audioLocalPath: audioLocalPath
        )
        messages.append(message)
        onMessageAppended?(messages.count - 1)
    }

    private func buildHistoryPrompt(language: String?, newText: String) -> String {
        var parts = ["Your response must be in the user's language that corresponds to the code: '\(language ?? "en")'"]
        
        let last = messages.suffix(8)
        if !last.isEmpty {
            parts.append("I am attaching the history of our correspondence for context")
            for msg in last {
                parts.append("\(msg.isFromUser ? "[user]: " : "[AI companion]: ") \(msg.text)")
            }
        }

        parts.append("And now I'm writing: \(newText)")
        return parts.joined(separator: "\n")
    }
}
