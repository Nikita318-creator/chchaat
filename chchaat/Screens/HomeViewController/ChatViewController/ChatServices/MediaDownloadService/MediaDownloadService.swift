//
//  MediaDownloadService.swift
//  chchaat
//

import Foundation

final class MediaDownloadService {
    static let shared = MediaDownloadService()
    
    private init() {}
    
    // ID — это строки
    private let whiteChatIds = ["1", "2", "4", "6", "9", "11"] // test111 - опреедели какому какой ид
    
    /// Боевой метод загрузки медиа
    /// - Parameters:
    ///   - isVideo: Флаг видео/фото
    ///   - id: Единый строковый ID (и для чата, и для персонажа)
    ///   - completion: Возвращает локальный URL файла или ошибку
    func downloadMedia(
        isVideo: Bool,
        id: String,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        let fileManager = FileManager.default
        guard let appSupportDir = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            completion(.failure(NSError(domain: "MediaDownloadService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Application Support directory not found"])))
            return
        }

        // Создаем отдельную подпапку для медиачатов, чтобы не мусорить в корне Application Support
        let mediaDir = appSupportDir.appendingPathComponent("ChatMedia", isDirectory: true)
        try? fileManager.createDirectory(at: mediaDir, withIntermediateDirectories: true, attributes: nil)
        
        let index: Int
        let remoteURLString: String
        let fileName: String
        let trackingKey: String
        
        if isVideo {
            // Видео-логика: смотрим, есть ли строковый ID в белом списке
            let isWhite = whiteChatIds.contains(id)
            let totalCount = isWhite ? 94 : 99
            trackingKey = "downloaded_videos_\(isWhite ? "white" : "black")"
            
            // Рандом уникальных индексов, затем из кэша
            index = Self.selectRandomIndex(totalCount: totalCount, trackingKey: trackingKey)
            
            let basePath = BaseManager.shared.imagesPath2
            let ending = isWhite ? BaseManager.shared.whiteEnding : BaseManager.shared.blackEnding
            remoteURLString = basePath + ending + "\(index).mp4"
            fileName = (isWhite ? "white_clip_" : "black_clip_") + "\(index).mp4"
            
        } else {
            // Фото-логика: количество зависит от конкретного id персонажа
            let totalCount = photoCount(for: id)
            trackingKey = "downloaded_photos_char_\(id)"
            
            index = Self.selectRandomIndex(totalCount: totalCount, trackingKey: trackingKey)
            
            // Формат imageName: "{id}_{index}" (например, 13_16)
            let basePath = BaseManager.shared.imagesPath
            let ending = BaseManager.shared.imagesEnding
            remoteURLString = basePath + ending + "\(id)_\(index).jpg"
            fileName = "photo_\(id)_\(index).jpg"
        }
        
        let fileURL = mediaDir.appendingPathComponent(fileName)
        
        // 1. Проверяем локальный кэш
        if fileManager.fileExists(atPath: fileURL.path) {
            completion(.success(fileURL))
            return
        }
        
        // 2. Скачиваем по сети
        guard let url = URL(string: remoteURLString) else {
            completion(.failure(NSError(domain: "MediaDownloadService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid remote URL: \(remoteURLString)"])))
            return
        }
        
        let task = URLSession.shared.downloadTask(with: url) { tempURL, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            
            guard let tempURL = tempURL else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "MediaDownloadService", code: -3, userInfo: [NSLocalizedDescriptionKey: "Download failed, no temporary URL"])))
                }
                return
            }
            
            do {
                if fileManager.fileExists(atPath: fileURL.path) {
                    try fileManager.removeItem(at: fileURL)
                }
                try fileManager.moveItem(at: tempURL, to: fileURL)
                
                // Сохраняем индекс в UserDefaults
                Self.saveDownloadedIndex(index, forKey: trackingKey)
                
                DispatchQueue.main.async {
                    completion(.success(fileURL))
                }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
        task.resume()
    }
    
    /// Определение количества фото по строковому ID
    private func photoCount(for id: String) -> Int {
        let specificCounts: [String: Int] = [  // test111 - опреедели какому какой ид
            "1": 123, "2": 123, "3": 115, "4": 95, "5": 123,
            "6": 35,  "7": 115, "8": 58,  "9": 38, "10": 115
        ]
        
        if let count = specificCounts[id] {
            return count
        } else if let intId = Int(id), (11...20).contains(intId) {
            return 20 // У всех с "11" по "20" ровно по 20 фоток
        } else {
            return 20 // Дефолт для остальных
        }
    }
    
    private static func selectRandomIndex(totalCount: Int, trackingKey: String) -> Int {
        let allIndices = Array(1...totalCount)
        let downloaded = getDownloadedIndices(forKey: trackingKey)
        
        let remaining = allIndices.filter { !downloaded.contains($0) }
        
        if let randomRemaining = remaining.randomElement() {
            return randomRemaining
        } else {
            // Если всё выгружено, берем рандомно из всех
            return allIndices.randomElement() ?? 1
        }
    }
    
    private static func getDownloadedIndices(forKey key: String) -> Set<Int> {
        guard let array = UserDefaults.standard.array(forKey: key) as? [Int] else {
            return []
        }
        return Set(array)
    }
    
    private static func saveDownloadedIndex(_ index: Int, forKey key: String) {
        var downloaded = getDownloadedIndices(forKey: key)
        downloaded.insert(index)
        UserDefaults.standard.set(Array(downloaded), forKey: key)
    }
}
