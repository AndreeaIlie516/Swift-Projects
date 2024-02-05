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
        
        var color: Color {
            switch self {
            case .nature: return Color.mint
            case .food: return Color.red
            case .sport: return Color.blue
            }
        }
        
            
        }
    
    @State var theme: Theme = .nature
    @State var emojis: [String] = Theme.nature.emojis
    @State var cardCount: Int = Int.random(in: 4...9) * 2
    
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle)
            cards
            cardCountAdjusters
            themeAdjusters
        }
        .padding()
        .onAppear {
            switchTheme(to: theme)
        }
    }
    
    var cards: some View {
        GeometryReader { geometry in
            ScrollView {
                let width: CGFloat = widthThatBestFits(cardCount: cardCount, screenSize: geometry.size.width)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: width))]) {
                    ForEach(0..<cardCount, id: \.self) { index in
                        CardView(content: emojis[index % emojis.count])
                            .aspectRatio(2/3, contentMode: .fit)
                    }
                }
                .foregroundColor(theme.color)
            }
        }
    }
    
    func widthThatBestFits(cardCount: Int, screenSize: CGFloat) -> CGFloat {
        let aspectRatio: CGFloat = 2 / 3
        let screenWidth = screenSize - 40
        let numberOfRows: CGFloat = CGFloat(cardCount / 3).rounded(.up)
        let totalPadding: CGFloat = 10 * (numberOfRows - 1)
        let optimalWidth = (screenWidth - totalPadding) / numberOfRows
        return max(optimalWidth * aspectRatio, 65)
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
        cardCount = Int.random(in: 4...(newTheme.emojis.count / 2)) * 2
        shuffleEmojis(to: newTheme)
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
