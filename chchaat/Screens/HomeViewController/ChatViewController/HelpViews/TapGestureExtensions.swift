//
//  TapGestureExtensions.swift
//  chchaat
//

import UIKit

final class PhotoTapGesture: UITapGestureRecognizer {
    let message: MessageModel
    
    init(target: Any?, action: Selector?, message: MessageModel) {
        self.message = message
        super.init(target: target, action: action)
    }
}

final class VideoTapGesture: UITapGestureRecognizer {
    let message: MessageModel
    
    init(target: Any?, action: Selector?, message: MessageModel) {
        self.message = message
        super.init(target: target, action: action)
    }
}

