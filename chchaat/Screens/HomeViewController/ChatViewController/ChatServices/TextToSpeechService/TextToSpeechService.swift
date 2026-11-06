//  TextToSpeechService.swift
//  chchaat

import Foundation

struct VoiceConfig {
    let langTag: String
    let voiceName: String
    let pitch: Double?
    let speakingRate: Double
}

struct VoiceMapping {
    static func getConfig(for rawLanguage: String, isSweetForCartoon: Bool = false) -> VoiceConfig {
        let normalized = rawLanguage.lowercased()
            .replacingOccurrences(of: "_", with: "-")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let components = normalized.components(separatedBy: "-")
        let baseCode = components.first ?? ""
        
        let defaultRate: Double = 1.04
        
        // --- ПРОВЕРКА СПЕЦИФИЧЕСКИХ ЛОКАЛЕЙ ---
        if components.contains("tw") || components.contains("hk") || components.contains("hant") {
            return VoiceConfig(langTag: "zh-TW", voiceName: "zh-TW-Neural2-A", pitch: 1.6, speakingRate: defaultRate)
        }
        if components.contains("mx") || components.contains("419") || (baseCode == "es" && components.contains("us")) {
            return VoiceConfig(langTag: "es-MX", voiceName: "es-MX-Neural2-A", pitch: 1.8, speakingRate: defaultRate)
        }
        if components.contains("br") || (baseCode == "pt" && !components.contains("pt")) {
            return VoiceConfig(langTag: "pt-BR", voiceName: "pt-BR-Neural2-A", pitch: 1.8, speakingRate: defaultRate)
        }
        if baseCode == "fil" {
            return VoiceConfig(langTag: "fil-PH", voiceName: "fil-PH-Neural2-A", pitch: 1.8, speakingRate: defaultRate)
        }
        
        // --- СЕГМЕНТАЦИЯ ПО БАЗОВОМУ ЯЗЫКУ ---
        switch baseCode {
        case "en":
            if isSweetForCartoon {
                // Если нужен тюнинг / аниме-вайб — берем Neural2 и выкручиваем питч
                return VoiceConfig(langTag: "en-US", voiceName: "en-US-Neural2-F", pitch: 4.0, speakingRate: defaultRate)
            } else {
                // В обычном режиме — премиальный Journey (pitch обязательно nil, иначе Google выдаст ошибку)
                return VoiceConfig(langTag: "en-US", voiceName: "en-US-Journey-F", pitch: nil, speakingRate: defaultRate)
            }

        case "fr":
            if isSweetForCartoon {
                return VoiceConfig(langTag: "fr-FR", voiceName: "fr-FR-Neural2-A", pitch: 3.0, speakingRate: defaultRate)
            } else {
                return VoiceConfig(langTag: "fr-FR", voiceName: "fr-FR-Journey-F", pitch: nil, speakingRate: defaultRate)
            }

        case "it":
            if isSweetForCartoon {
                return VoiceConfig(langTag: "it-IT", voiceName: "it-IT-Neural2-A", pitch: 3.0, speakingRate: defaultRate)
            } else {
                return VoiceConfig(langTag: "it-IT", voiceName: "it-IT-Journey-F", pitch: nil, speakingRate: defaultRate)
            }

        case "ja":
            return VoiceConfig(langTag: "ja-JP", voiceName: "ja-JP-Neural2-B", pitch: 1.8, speakingRate: defaultRate)
        case "zh", "cmn":
            return VoiceConfig(langTag: "cmn-CN", voiceName: "cmn-CN-Neural2-F", pitch: 1.8, speakingRate: defaultRate)
        case "de":
            return VoiceConfig(langTag: "de-DE", voiceName: "de-DE-Neural2-C", pitch: 1.5, speakingRate: defaultRate)
        case "es":
            return VoiceConfig(langTag: "es-ES", voiceName: "es-ES-Neural2-C", pitch: 1.8, speakingRate: defaultRate)
        case "ko":
            return VoiceConfig(langTag: "ko-KR", voiceName: "ko-KR-Neural2-A", pitch: 1.6, speakingRate: defaultRate)
        case "ar":
            return VoiceConfig(langTag: "ar-XA", voiceName: "ar-XA-Neural2-A", pitch: 1.8, speakingRate: defaultRate)
        case "sv":
            return VoiceConfig(langTag: "sv-SE", voiceName: "sv-SE-Neural2-C", pitch: 1.8, speakingRate: defaultRate)
        case "da":
            return VoiceConfig(langTag: "da-DK", voiceName: "da-DK-Neural2-A", pitch: 1.6, speakingRate: defaultRate)
        case "no", "nb", "nn":
            return VoiceConfig(langTag: "no-NO", voiceName: "no-NO-Neural2-A", pitch: 1.6, speakingRate: defaultRate)
        case "pt":
            return VoiceConfig(langTag: "pt-PT", voiceName: "pt-PT-Neural2-A", pitch: 1.8, speakingRate: defaultRate)
            
        default:
            if isSweetForCartoon {
                return VoiceConfig(langTag: "en-US", voiceName: "en-US-Neural2-F", pitch: 2.0, speakingRate: defaultRate)
            } else {
                return VoiceConfig(langTag: "en-US", voiceName: "en-US-Journey-F", pitch: nil, speakingRate: defaultRate)
            }
        }
    }
}

final class TextToSpeechService {
    static let shared = TextToSpeechService()
    
    // Вставьте ваш API ключ под эту задачу
    private let apiKey = "AIzaSyAisC2WeP" + BaseManager.shared.audioKey
    
    func synthesizeSpeech(text: String, rawLanguage: String = Locale.current.identifier, isAnime: Bool = false, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let url = URL(string: "https://texttospeech.googleapis.com/v1/text:synthesize?key=\(apiKey)") else {
            completion(.failure(NSError(domain: "TTS", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let voiceConfig = VoiceMapping.getConfig(for: rawLanguage, isSweetForCartoon: isAnime)
        
        // Формируем audioConfig динамически: если pitch == nil (для Journey голосов), мы его НЕ передаем в запрос, чтобы Google не падал с ошибкой
        var audioConfig: [String: Any] = [
            "audioEncoding": "MP3",
            "speakingRate": voiceConfig.speakingRate
        ]
        if let pitch = voiceConfig.pitch {
            audioConfig["pitch"] = pitch
        }
        
        let body: [String: Any] = [
            "input": ["text": text],
            "voice": [
                "languageCode": voiceConfig.langTag,
                "name": voiceConfig.voiceName,
                "ssmlGender": "FEMALE"
            ],
            "audioConfig": audioConfig
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "TTS", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let audioContent = json["audioContent"] as? String,
                   let audioData = Data(base64Encoded: audioContent) {
                    
                    // Сохраняем в Caches директорию
                    let fileName = "\(UUID().uuidString).mp3"
                    let cachesDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
                    let fileURL = cachesDir.appendingPathComponent(fileName)
                    
                    try audioData.write(to: fileURL)
                    completion(.success(fileURL))
                } else {
                    let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                    completion(.failure(NSError(domain: "TTS", code: -3, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
