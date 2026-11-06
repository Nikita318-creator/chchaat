//
//  Base.swift
//  chchaat
//

import Foundation

final class BaseManager {
    static let shared = BaseManager()

    // Публичные параметры для использования в коде
    private(set) var audioKey: String = ""
    private(set) var imagesPath: String = ""
    private(set) var imagesPath2: String = ""
    private(set) var imagesEnding: String = ""
    private(set) var whiteEnding: String = ""
    private(set) var blackEnding: String = ""
    private(set) var animeEnding: String = ""
    
    private(set) var isSynced: Bool = false

    private let defaults = UserDefaults.standard
    private let syncKey = "is_base_config_synced"
    
    private enum Keys {
        static let audioKey = "config_audioKey"
        static let imagesPath = "config_imagesPath"
        static let imagesPath2 = "config_imagesPath2"
        static let imagesEnding = "config_imagesEnding"
        static let whiteEnding = "config_whiteEnding"
        static let blackEnding = "config_blackEnding"
        static let animeEnding = "config_animeEnding"
    }

    private init() {
        loadFromUserDefaults()
    }

    /// Загрузка сохраненных параметров из UserDefaults
    func loadFromUserDefaults() {
        if defaults.bool(forKey: syncKey) {
            audioKey = defaults.string(forKey: Keys.audioKey) ?? ""
            imagesPath = defaults.string(forKey: Keys.imagesPath) ?? ""
            imagesPath2 = defaults.string(forKey: Keys.imagesPath2) ?? ""
            imagesEnding = defaults.string(forKey: Keys.imagesEnding) ?? ""
            whiteEnding = defaults.string(forKey: Keys.whiteEnding) ?? ""
            blackEnding = defaults.string(forKey: Keys.blackEnding) ?? ""
            animeEnding = defaults.string(forKey: Keys.animeEnding) ?? ""
            isSynced = true
        }
    }

    /// Запрос конфигурации с бэка при старте
    func fetchConfigIfNeeded(appSecret: String, completion: (() -> Void)? = nil) {
        guard !isSynced else {
            completion?()
            return
        }
        
        guard let url = URL(string: "https://core-sync-service-138319918962.us-central1.run.app/api/v1/config") else {
            completion?()
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(appSecret, forHTTPHeaderField: "X-App-Secret")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            defer {
                DispatchQueue.main.async {
                    completion?()
                }
            }
            
            guard let self = self,
                  let data = data,
                  error == nil,
                  let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let json = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] else {
                return
            }
            
            let fetchedAudioKey = json["audioKey"] as? String ?? ""
            let fetchedImagesPath = json["imagesPath"] as? String ?? ""
            let fetchedImagesPath2 = json["imagesPath2"] as? String ?? ""
            let fetchedImagesEnding = json["imagesEnding"] as? String ?? ""
            let fetchedWhiteEnding = json["whiteEnding"] as? String ?? ""
            let fetchedBlackEnding = json["blackEnding"] as? String ?? ""
            let fetchedAnimeEnding = json["AnimeEnding"] as? String ?? ""
            
            // Записываем в свойства
            self.audioKey = fetchedAudioKey
            self.imagesPath = fetchedImagesPath
            self.imagesPath2 = fetchedImagesPath2
            self.imagesEnding = fetchedImagesEnding
            self.whiteEnding = fetchedWhiteEnding
            self.blackEnding = fetchedBlackEnding
            self.animeEnding = fetchedAnimeEnding
            
            // Сохраняем в UserDefaults
            self.defaults.set(fetchedAudioKey, forKey: Keys.audioKey)
            self.defaults.set(fetchedImagesPath, forKey: Keys.imagesPath)
            self.defaults.set(fetchedImagesPath2, forKey: Keys.imagesPath2)
            self.defaults.set(fetchedImagesEnding, forKey: Keys.imagesEnding)
            self.defaults.set(fetchedWhiteEnding, forKey: Keys.whiteEnding)
            self.defaults.set(fetchedBlackEnding, forKey: Keys.blackEnding)
            self.defaults.set(fetchedAnimeEnding, forKey: Keys.animeEnding)
            self.defaults.set(true, forKey: self.syncKey)
            
            self.isSynced = true
        }
        
        task.resume()
    }
}
