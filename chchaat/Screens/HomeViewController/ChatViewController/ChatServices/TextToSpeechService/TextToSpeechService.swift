//  TextToSpeechService.swift
//  chchaat

import Foundation

final class TextToSpeechService {
    static let shared = TextToSpeechService()
    
    // Вставьте ваш API ключ под эту задачу
    private let apiKey = "AIzaSyAisC2WeP" + BaseManager.shared.audioKey // test111c"ВАШ_АПИ_КЕЙ"
    
    func synthesizeSpeech(text: String, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let url = URL(string: "https://texttospeech.googleapis.com/v1/text:synthesize?key=\(apiKey)") else {
            completion(.failure(NSError(domain: "TTS", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "input": ["text": text],
            "voice": ["languageCode": "en-US", "ssmlGender": "NEUTRAL"],
            "audioConfig": ["audioEncoding": "MP3"]
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
