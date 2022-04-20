//
//  LanguagePairView.swift
//  Morse
//
//  Created by Tamerlan Satualdypov on 16.04.2022.
//

import SwiftUI

struct LanguagePairView: View {
    @Binding var languagePair: LanguagePair
    
    var body: some View {
        HStack {
            self.languageItemView(for: self.languagePair.leftItem)
            
            Image(systemName: "chevron.forward")
                .foregroundColor(.accentColor)
                .font(.system(size: 24.0, weight: .semibold))
            
            self.languageItemView(for: self.languagePair.rightItem)
        }
    }
    
    private func languageItemView(for language: Language) -> some View {
        Text(language.rawValue)
            .padding(8.0)
            .frame(maxWidth: .infinity)
            .background(Color.secondarySystemBackground)
            .cornerRadius(8.0)
    }
}
