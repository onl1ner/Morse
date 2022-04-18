//
//  MorseTranslation.swift
//  Morse
//
//  Created by Tamerlan Satualdypov on 18.04.2022.
//

import Foundation

struct MorseTranslation {
    let originTokens: [String]
    let translatedTokens: [String]
    
    var originText: String {
        return self.originTokens.joined(separator: " ")
    }
    
    var translatedText: String {
        return self.translatedTokens.joined(separator: " ")
    }
}
