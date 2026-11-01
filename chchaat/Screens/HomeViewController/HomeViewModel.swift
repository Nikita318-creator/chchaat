//
//  HomeViewModel.swift
//  chchaat
//
//  Created by Mikita on 01/11/2026.
//

import UIKit

// MARK: - Model
struct AICharacter {
    let id: String
    let name: String
    let age: Int
    let bio: String
    let tagline: String
}

// MARK: - ViewModel
final class HomeViewModel {
    let characters: [AICharacter] = [
        AICharacter(
            id: "1",
            name: "Aria",
            age: 22,
            bio: "Your cyberpunk companion. Always online, ready for late-night chats, secrets, and deep conversations.",
            tagline: "Cyberpunk Vibe"
        ),
        AICharacter(
            id: "2",
            name: "Chloe",
            age: 21,
            bio: "Sweet and caring art student who loves coffee, cozy moments, and sharing daily thoughts with you.",
            tagline: "Cozy & Sweet"
        ),
        AICharacter(
            id: "3",
            name: "Scarlett",
            age: 24,
            bio: "Confident, witty, and sharp. Let's talk about ambition, philosophy, or just tease each other all night.",
            tagline: "Witty & Bold"
        )
    ]
}
