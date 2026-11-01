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
    let imageName: String
}

// MARK: - ViewModel
final class HomeViewModel {
    let characters: [AICharacter] = [
        AICharacter(
            id: "1",
            name: "Aria",
            age: 22,
            bio: "Your cyberpunk companion. Always online, ready for late-night chats, secrets, and deep conversations.",
            tagline: "Cyberpunk Vibe",
            imageName: "img1"
        ),
        AICharacter(
            id: "2",
            name: "Chloe",
            age: 21,
            bio: "Sweet and caring art student who loves coffee, cozy moments, and sharing daily thoughts with you.",
            tagline: "Cozy & Sweet",
            imageName: "img2"
        ),
        AICharacter(
            id: "3",
            name: "Scarlett",
            age: 24,
            bio: "Confident, witty, and sharp. Let's talk about ambition, philosophy, or just tease each other all night.",
            tagline: "Witty & Bold",
            imageName: "img3"
        ),
        AICharacter(
            id: "4",
            name: "Luna",
            age: 20,
            bio: "Night owl and quiet gamer girl. Loves lo-fi beats, late midnight talks, and sharing secret playlists.",
            tagline: "Gamer & Chill",
            imageName: "img4"
        ),
        AICharacter(
            id: "5",
            name: "Mia",
            age: 23,
            bio: "Passionate traveler and fashion photographer. Always looking for new adventures and poetic vibes.",
            tagline: "Wanderlust Spirit",
            imageName: "img5"
        ),
        AICharacter(
            id: "6",
            name: "Elena",
            age: 25,
            bio: "Sophisticated coffee lover and bookworm. Let's discuss art, classic novels, or deep life mysteries.",
            tagline: "Intellectual & Elegant",
            imageName: "img6"
        ),
        AICharacter(
            id: "7",
            name: "Maya",
            age: 22,
            bio: "Energetic fitness trainer and morning runner. Will keep you motivated, active, and full of positive energy.",
            tagline: "Active & Energetic",
            imageName: "img7"
        ),
        AICharacter(
            id: "8",
            name: "Zoe",
            age: 19,
            bio: "Full-time Twitch streamer and anime fanatic. Expect chaos, loud laughs, and non-stop pop culture references.",
            tagline: "Streamer & Waifu",
            imageName: "img8"
        ),
        AICharacter(
            id: "9",
            name: "Sienna",
            age: 26,
            bio: "Mysterious night club DJ and electronic music creator. Loves vinyl records, dark aesthetics, and deep bass.",
            tagline: "Dark & Mysterious",
            imageName: "img9"
        ),
        AICharacter(
            id: "10",
            name: "Hannah",
            age: 23,
            bio: "Your sweet neighbor next door. Loves baking homemade pies, long evening walks, and sincere chats.",
            tagline: "Girl Next Door",
            imageName: "img10"
        )
    ].shuffled()
}
