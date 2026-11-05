//
//  SpeechRecognitionService.swift
//  chchaat
//

import Foundation
import Speech
import AVFoundation

final class SpeechRecognitionService: NSObject {
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    var onTranscription: ((String) -> Void)?
    var onError: ((Error) -> Void)?

    private func getRecognizer(for languageCode: String?) -> SFSpeechRecognizer? {
        let identifier: String
        if let lang = languageCode, !lang.isEmpty {
            identifier = lang
        } else if let preferred = Locale.preferredLanguages.first {
            identifier = preferred
        } else {
            identifier = Locale.current.identifier
        }
        
        // Создаем рекогнайзер под конкретную локаль (поддерживаются все языки системы)
        return SFSpeechRecognizer(locale: Locale(identifier: identifier))
    }

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                completion(authStatus == .authorized)
            }
        }
    }

    func startRecording(languageCode: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: [.duckOthers])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            completion(.failure(error))
            return
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            completion(.failure(NSError(domain: "SpeechService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось создать запрос распознавания"])))
            return
        }

        recognitionRequest.shouldReportPartialResults = true

        guard let speechRecognizer = getRecognizer(for: languageCode), speechRecognizer.isAvailable else {
            completion(.failure(NSError(domain: "SpeechService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Распознавание речи недоступно для выбранного языка"])))
            return
        }

        let inputNode = audioEngine.inputNode

        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            var isFinal = false

            if let result = result {
                let transcribedString = result.bestTranscription.formattedString
                self?.onTranscription?(transcribedString)
                isFinal = result.isFinal
            }

            if error != nil || isFinal {
                self?.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self?.recognitionRequest = nil
                self?.recognitionTask = nil
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }

        do {
            audioEngine.prepare()
            try audioEngine.start()
            completion(.success(()))
        } catch {
            audioEngine.stop()
            inputNode.removeTap(onBus: 0)
            self.recognitionRequest = nil
            recognitionTask = nil
            completion(.failure(error))
        }
    }

    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil

        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Не удалось деактивировать аудиосессию: \(error)")
        }
    }
}
