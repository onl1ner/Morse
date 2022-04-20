//
//  TranslationView.swift
//  Morse
//
//  Created by Tamerlan Satualdypov on 20.04.2022.
//

import SwiftUI

struct TranslationView: View {
    let translation: MorseTranslation
    
    var body: some View {
        WrappedStack(source: 0 ..< translation.originTokens.count) { tokenIndex in
            TokenView(
                originToken: self.translation.originTokens[tokenIndex],
                translatedToken: self.translation.translatedTokens[tokenIndex],
                languagePair: self.translation.languagePair
            )
        }
    }
}
