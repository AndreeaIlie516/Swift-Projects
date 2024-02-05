//
//  ContentView.swift
//  Memorize
//
//  Created by Andreea Ilie on 30.01.2024.
//

import SwiftUI

struct ContentView: View {
    
    enum Theme: Int, CaseIterable {
            case nature, food, sport
            
            var name: String {
                switch self {
                case .nature: return "Nature"
                case .food: return "Food"
                case .sport: return "Sport"
                }
            }
            
            var symbol: String {
                switch self {
                case .nature: return "mountain.2.fill"
                case .food: return "carrot.fill"
                case .sport: return "basketball.fill"
                }
            }
            
            var emojis: [String] {
                switch self {
                case .nature: return ["⛰️", "🍃", "🦋", "🌊", "🌸", "🦔","🏕️", "🐌", "🏝️", "🍄", "🐚", "🪺", "🪷", "🐝", "🌳", "🐬", "🪸", "🦚"]
                case .food: return ["🍉", "🍕", "🌮", "🥐", "🍓", "🍔", "🥟", "🍰", "🍤", "🥗", "🥨", "🥞", "🫐"]
                case .sport: return ["⚽️", "🏓", "⛸️", "🏈", "🎾", "🛹", "🏸", "🥍", "🏐", "🏊‍♂️", "🏹", "🧗‍♀️"]
                }
            }
        }
    
    
    @State var cardCount: Int = 8
    @State var theme: Theme = .nature
    @State var emojis: [String] = Theme.nature.emojis
    
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle)
            ScrollView {
                cards
            }
            cardCountAdjusters
            themeAdjusters
        }
        .padding()
        .onAppear {
            switchTheme(to: theme)
        }
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(),GridItem(), GridItem(), GridItem()]) {
            ForEach(0..<cardCount, id: \.self) { index in
                CardView(content: emojis[index])
                    .aspectRatio(2/3, contentMode: .fit)
                
            }
        }
        .foregroundColor(.mint)
    }
    
    var cardCountAdjusters: some View {
        HStack {
            cardRemover
            Spacer()
            cardAdder
        }
        .imageScale(.large)
        .font(.largeTitle)
    }
    
    func cardCountAdjuster(by offset: Int, symbol: String) -> some View {
        Button(action: {
            cardCount += offset
            shuffleEmojis(to: theme)
        }, label: {
            Image(systemName: symbol)
        })
        .disabled(cardCount + offset < 8 || cardCount + offset > theme.emojis.count * 2)
    }
    
    var cardRemover: some View {
        cardCountAdjuster(by: -2, symbol: "minus.circle")
    }
    
    var cardAdder: some View {
        cardCountAdjuster(by: +2, symbol:  "plus.circle")
    }
    
    var themeAdjusters: some View {
        HStack {
            Spacer()
            ForEach(Theme.allCases, id: \.self) {
                themeOption in
                themeAdjuster(for: themeOption)
                Spacer()
            }

        }
        .imageScale(.large)
        .padding(.horizontal, 70)
    }
    
    func themeAdjuster(for theme: Theme) -> some View {
        VStack {
            Button(action: {
                switchTheme(to: theme)
            }, label: {
                Image(systemName: theme.symbol)
            })
            Text(theme.name).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
        }
    }
    
    func switchTheme(to newTheme: Theme) {
        theme = newTheme
        shuffleEmojis(to: newTheme)
        cardCount = min(cardCount, emojis.count)
    }
    
    func shuffleEmojis(to theme: Theme) {
        let shuffledEmojis = theme.emojis.shuffled()
        let numberOfUniqueEmojisNeeded = cardCount / 2
        let emojiSubset = Array(shuffledEmojis.prefix(numberOfUniqueEmojisNeeded))
        emojis = (emojiSubset + emojiSubset).shuffled()
    }
}

struct CardView: View {
    let content: String
    @State var isFaceUp: Bool = false
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content).font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            base.fill().opacity(isFaceUp ? 0 : 1)
        }.onTapGesture {
            isFaceUp.toggle()
        }
    }
}

#Preview {
    ContentView()
}
