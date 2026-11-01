//
//  NeuralDispatcher.swift
//  chchaat
//

import Foundation

struct NeuralPayload: Encodable, Sendable {
    let history: String
    let targetVersion: String
    
    enum CodingKeys: String, CodingKey {
        case history = "history"
        case targetVersion = "app_version"
    }
}

struct NeuralResponse: Decodable, Sendable {
    let outputText: String?
    let failReason: String?
    
    enum CodingKeys: String, CodingKey {
        case outputText = "response"
        case failReason = "error"
    }
}

final class NeuralDispatcher: Sendable {
    static let shared = NeuralDispatcher()
    
    private let backendLink = "https://core-sync-service-138319918962.us-central1.run.app/api/v1/sync"
    private let httpHeader = "test_it_again_its_not_working"
    
    private var bundleVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }
    
    func send(history: String) async throws -> String {
        guard let url = URL(string: backendLink) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(httpHeader, forHTTPHeaderField: "X-App-Secret")
        
        let payload = NeuralPayload(
            history: history,
            targetVersion: bundleVersion
        )
        
        request.httpBody = try JSONEncoder().encode(payload)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.cannotParseResponse)
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            let errorText = String(data: data, encoding: .utf8) ?? "HTTP \(httpResponse.statusCode)"
            throw NSError(domain: "NeuralDispatcher", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorText])
        }
        
        let decoded = try JSONDecoder().decode(NeuralResponse.self, from: data)
        
        if let result = decoded.outputText, !result.isEmpty {
            return result
        } else if let failReason = decoded.failReason {
            throw NSError(domain: "NeuralDispatcher", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: failReason])
        } else {
            throw URLError(.cannotParseResponse)
        }
    }
}
