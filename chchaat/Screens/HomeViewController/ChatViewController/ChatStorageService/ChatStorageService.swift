//
//  ChatStorageService.swift
//  chchaat

import Foundation
import RealmSwift

final class MessageModel: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var characterId: String = ""
    @Persisted var text: String = ""
    @Persisted var isFromUser: Bool = true
    @Persisted var timestamp: Date = Date()
}

final class ChatStorageService {
    static let shared = ChatStorageService()
    
    private let mainConfiguration: Realm.Configuration

    private init() {
        var config = Realm.Configuration.defaultConfiguration
        config.schemaVersion = 1
        config.migrationBlock = { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                // Будущие миграции
            }
        }
        
        do {
            _ = try Realm(configuration: config)
            self.mainConfiguration = config
        } catch {
            print("⚠️ [Realm] Disk init failed: \(error). Falling back to In-Memory.")
            // fileURL должен быть nil, так как fileURL и inMemoryIdentifier взаимоисключающие
            self.mainConfiguration = Realm.Configuration(
                fileURL: nil,
                inMemoryIdentifier: "EmergencyMemoryRealm",
                schemaVersion: 1
            )
        }
    }

    private var realm: Realm {
        do {
            return try Realm(configuration: mainConfiguration)
        } catch {
            print("⚠️ [Realm] Thread-local open failed: \(error). Using emergency in-memory.")
            let emergencyConfig = Realm.Configuration(
                fileURL: nil,
                inMemoryIdentifier: "EmergencyMemoryRealm"
            )
            return try! Realm(configuration: emergencyConfig)
        }
    }

    func fetchMessages(for characterId: String) -> [MessageModel] {
        let currentRealm = realm
        let predicate = NSPredicate(format: "characterId == %@", characterId)
        let results = currentRealm.objects(MessageModel.self)
            .filter(predicate)
            .sorted(byKeyPath: "timestamp", ascending: true)
        
        return Array(results.freeze())
    }

    @discardableResult
    func saveMessage(characterId: String, text: String, isFromUser: Bool) -> MessageModel {
        let message = MessageModel()
        message.characterId = characterId
        message.text = text
        message.isFromUser = isFromUser
        message.timestamp = Date()

        let currentRealm = realm
        do {
            try currentRealm.write {
                currentRealm.add(message, update: .modified)
            }
        } catch {
            print("❌ [Realm] Write transaction error: \(error)")
        }
        
        return message.freeze()
    }
}
