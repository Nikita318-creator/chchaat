//
//  AppColors.swift
//  chchaat
//
//

import UIKit

struct AppColors {
    // Base Backgrounds (Deep Obsidian / Midnight Slate)
    static let background = UIColor(red: 0.06, green: 0.07, blue: 0.09, alpha: 1.0)     // #0F1117
    static let surface = UIColor(red: 0.10, green: 0.11, blue: 0.16, alpha: 1.0)        // #1A1D29 (Cards, Input Bar)
    static let surfaceElevated = UIColor(red: 0.14, green: 0.15, blue: 0.21, alpha: 1.0) // #232736
    
    // Accents & Tints (Vibrant Amethyst / Neon Violet)
    static let tint = UIColor(red: 0.55, green: 0.36, blue: 0.96, alpha: 1.0)          // #8B5CF6
    static let tintSecondary = UIColor(red: 0.75, green: 0.45, blue: 0.98, alpha: 1.0)  // #C084FC
    
    // Chat Bubbles
    static let bubbleIncoming = UIColor(red: 0.12, green: 0.13, blue: 0.19, alpha: 1.0)  // #1E2230
    static let bubbleOutgoing = UIColor(red: 0.49, green: 0.23, blue: 0.93, alpha: 1.0)  // #7C3AED
    
    // Text Hierarchy
    static let textPrimary = UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1.0)    // #F3F4F6
    static let textSecondary = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1.0)  // #9CA3AF
    static let textMuted = UIColor(red: 0.42, green: 0.46, blue: 0.53, alpha: 1.0)      // #6B7280
    
    // UI Elements
    static let link = UIColor(red: 0.22, green: 0.74, blue: 0.97, alpha: 1.0)          // #38BDF8
    static let separator = UIColor(red: 0.16, green: 0.18, blue: 0.24, alpha: 1.0)     // #2A2E3D
    static let destructive = UIColor(red: 0.94, green: 0.25, blue: 0.37, alpha: 1.0)   // #F43F5E
    
    static let chatBgTop = UIColor(red: 0.06, green: 0.07, blue: 0.09, alpha: 1.0)     // #0F1117
    static let chatBgBottom = UIColor(red: 0.09, green: 0.06, blue: 0.15, alpha: 1.0)  // Deep Amethyst Dark Gradient
    static let onlineIndicator = UIColor(red: 0.30, green: 0.85, blue: 0.39, alpha: 1.0) // #4ADE80
    static let typingIndicator = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1.0) // #9CA3AF
}

struct AppGradients {
    static var primaryButton: CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.55, green: 0.36, blue: 0.96, alpha: 1.0).cgColor, // #8B5CF6
            UIColor(red: 0.91, green: 0.27, blue: 0.69, alpha: 1.0).cgColor  // #E879F9 (Soft Pink Gradient Stop)
        ]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradient
    }
    
    static func chatBackground(for frame: CGRect) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [
            AppColors.chatBgTop.cgColor,
            AppColors.chatBgBottom.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = frame
        return gradient
    }
}
