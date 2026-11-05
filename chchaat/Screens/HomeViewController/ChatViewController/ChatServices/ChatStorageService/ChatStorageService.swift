//  ChatStorageService.swift
//  chchaat

import Foundation
import Realm
import RealmSwift

final class MessageModel: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var characterId: String = ""
    @Persisted var text: String = ""
    @Persisted var isFromUser: Bool = true
    @Persisted var timestamp: Date = Date()
    @Persisted var isAudioMessage: Bool = false
    @Persisted var audioLocalPath: String? = nil
}

final class ChatStorageService {
    static let shared = ChatStorageService()
    
    private let mainConfiguration: Realm.Configuration

    private init() {
        var config = Realm.Configuration.defaultConfiguration
        config.schemaVersion = 2
        config.migrationBlock = { migration, oldSchemaVersion in
            if oldSchemaVersion < 2 {
                migration.enumerateObjects(ofType: "MessageModel") { oldObject, newObject in
                    newObject?["isAudioMessage"] = false
                    newObject?["audioLocalPath"] = nil
                }
            }
        }
        
        do {
            _ = try Realm(configuration: config)
            self.mainConfiguration = config
        } catch {
            print("⚠️ [Realm] Disk init failed: \(error). Falling back to In-Memory.")
            self.mainConfiguration = Realm.Configuration(
                fileURL: nil,
                inMemoryIdentifier: "EmergencyMemoryRealm",
                schemaVersion: 2
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
    func saveMessage(
        characterId: String,
        text: String,
        isFromUser: Bool,
        isAudioMessage: Bool = false,
        audioLocalPath: String? = nil
    ) -> MessageModel {
        let message = MessageModel()
        message.characterId = characterId
        message.text = text
        message.isFromUser = isFromUser
        message.timestamp = Date()
        message.isAudioMessage = isAudioMessage
        message.audioLocalPath = audioLocalPath

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
