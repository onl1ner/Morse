//
//  MorseTranslator.swift
//  Morse
//
//  Created by Tamerlan Satualdypov on 18.04.2022.
//

import Foundation

struct MorseTranslator {
    private let alphabet: MorseAlphabet = .init()
    
    func translate(
        text: String,
        from originLanguage: Language,
        to translationLanguage: Language
    ) -> MorseTranslation {
        let originTokens: [String] = text.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
        var translatedTokens: [String] = .init()
        
        for token in originTokens {
            var translatedToken: [String] = .init()
            
            for symbol in token {
                if translationLanguage == .morse {
                    translatedToken.append(self.alphabet.morse(for: String(symbol).uppercased()))
                } else {
                    translatedToken.append(self.alphabet.letter(for: String(symbol).uppercased()))
                }
            }
            
            translatedTokens.append(translatedToken.joined())
        }
        
        return MorseTranslation(
            originLanguage: originLanguage,
            translationLanguage: translationLanguage,
            originTokens: originTokens,
            translatedTokens: translatedTokens
        )
    }
}
