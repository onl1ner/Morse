//
//  TranslationView.swift
//  Morse
//
//  Created by Tamerlan Satualdypov on 20.04.2022.
//

import SwiftUI

struct TranslationView: View {
    let translation: MorseTranslation
    
    private let player: MorseRadioTonePlayer = .init()
    
    @State private var isPlaying: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("To \(self.translation.languagePair.rightItem.rawValue)")
                        .font(.headline)
                        .foregroundColor(.secondaryLabel)
                    
                    WrappedStack(source: 0 ..< translation.originTokens.count) { tokenIndex in
                        TokenView(
                            originToken: self.translation.originTokens[tokenIndex],
                            translatedToken: self.translation.translatedTokens[tokenIndex],
                            languagePair: self.translation.languagePair
                        )
                    }
                }
            }
            
            HStack {
                self.copyButton
                
                Spacer()
                
                self.playButton
            }
        }
    }
    
    private var copyButton: some View {
        Button {
            UIPasteboard.general.string = self.translation.translatedText
        } label: {
            Image(systemName: "doc.on.doc")
                .font(.system(size: 24.0))
                .foregroundColor(.accentColor)
        }
    }
    
    private var playButton: some View {
        Button {
            self.isPlaying.toggle()
            
            if self.isPlaying {
                self.player.enableSpeaker()
                self.player.play(morse: self.translation.translatedText) {
                    self.isPlaying = false
                }
            } else {
                self.player.stop()
            }
        } label: {
            Image(systemName: self.isPlaying ? "stop.circle.fill" : "play.circle.fill")
                .font(.system(size: 40.0))
                .foregroundColor(.accentColor)
        }
    }
}
