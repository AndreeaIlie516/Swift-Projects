//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Andreea Ilie on 30.01.2024.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
