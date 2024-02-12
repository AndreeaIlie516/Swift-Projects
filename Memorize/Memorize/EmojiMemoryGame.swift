//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Andreea Ilie on 06.02.2024.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    static let emojis = ["⛰️", "🍃", "🦋", "🌊", "🌸", "🦔","🏕️", "🐌", "🏝️", "🍄", "🐚", "🪺", "🪷", "🐝", "🌳", "🐬", "🪸", "🦚"]
    
    private  static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame(numberOfPairsOfCards: 16) { pairIndex in
            if emojis.indices.contains(pairIndex) {
                return emojis[pairIndex]
            } else {
                return "⁉️"
            }
        }
    }
    
    @Published private var model = createMemoryGame()
    
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    // MARK: - Intents
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}
