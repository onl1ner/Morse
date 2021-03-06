//
//  TextView.swift
//  Morse
//
//  Created by Tamerlan Satualdypov on 18.04.2022.
//

import SwiftUI

struct TextView: View {
    let placeholder: String
    
    @Binding var text: String
    @FocusState var focus: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            TextEditor(text: self.$text)
                .font(.system(size: 32.0, weight: .bold))
                .foregroundColor(.label)
                .focused(self.$focus)
            
            // Using second TextEditor in order to
            // get same content text paddings.
            if self.text.isEmpty {
                TextEditor(text: .constant(self.placeholder))
                    .disabled(true)
                    .font(.system(size: 32.0, weight: .bold))
                    .foregroundColor(.placeholderText)
            }
        }
    }
}
