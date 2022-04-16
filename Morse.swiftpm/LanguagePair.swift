//
//  LanguagePair.swift
//  Morse
//
//  Created by Tamerlan Satualdypov on 16.04.2022.
//

import Foundation

struct LanguagePair {
    var leftItem: Language
    var rightItem: Language
    
    mutating func reverse() {
        let tmp = self.leftItem
        
        self.leftItem = self.rightItem
        self.rightItem = tmp
    }
}
