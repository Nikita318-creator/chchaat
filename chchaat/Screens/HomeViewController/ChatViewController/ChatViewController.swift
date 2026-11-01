//
//  ChatViewController.swift
//  chchaat
//

import UIKit
import SnapKit


// MARK: - Stub Chat Controller
final class ChatViewController: UIViewController {
    private let character: AICharacter

    init(character: AICharacter) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        title = character.name
        navigationController?.navigationBar.tintColor = AppColors.tint
        
        // Chat screen implementation goes here...
    }
}
