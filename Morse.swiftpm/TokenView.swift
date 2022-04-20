//
//  MorseTokenView.swift
//  Morse
//
//  Created by Tamerlan Satualdypov on 20.04.2022.
//

import SwiftUI

struct TokenView: View {
    enum Kind {
        case origin
        case translated
        
        mutating func toggle() {
            switch self {
            case .origin:
                self = .translated
            case .translated:
                self = .origin
            }
        }
    }
    
    private let tokenSize: CGFloat = 24.0
    
    private let originToken: String
    private let translatedToken: String
    
    private let languagePair: LanguagePair
    
    @State private var kind: Kind = .translated
    
    init(
        originToken: String,
        translatedToken: String,
        languagePair: LanguagePair
    ) {
        self.originToken = originToken
        self.translatedToken = translatedToken
        
        self.languagePair = languagePair
    }
    
    var body: some View {
        Group {
            switch self.kind {
            case .origin:
                self.contentView(
                    for: self.originToken,
                    language: self.languagePair.leftItem
                )
            case .translated:
                self.contentView(
                    for: self.translatedToken,
                    language: self.languagePair.rightItem
                )
            }
        }
        .frame(height: 40.0)
        .padding(.horizontal, 16.0)
        .background(Color.systemBackground)
        .cornerRadius(8.0)
        .onTapGesture {
            withAnimation {
                self.kind.toggle()
            }
        }
    }
    
    @ViewBuilder
    private func contentView(for text: String, language: Language) -> some View {
        switch language {
        case .english:
            Text(text)
                .font(.system(size: self.tokenSize, weight: .bold))
                .transition(.scale.combined(with: .opacity))
        case .morse:
            morseView(symbols: .init(text))
                .transition(.scale.combined(with: .opacity))
        }
    }
    
    private func morseView(symbols: [String.Element]) -> some View {
        HStack(spacing: 2.0) {
            ForEach(0 ..< symbols.count) { index in
                self.morseSymbolView(for: .init(symbols[index]))
            }
        }
    }
    
    @ViewBuilder
    private func morseSymbolView(for character: String) -> some View {
        if character == "." {
            Image(systemName: "circlebadge.fill")
                .font(.system(size: self.tokenSize / 2.0, weight: .regular))
        } else {
            Image(systemName: "minus")
                .font(.system(size: self.tokenSize, weight: .heavy))
        }
    }
}
