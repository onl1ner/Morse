//
//  RoundedRect.swift
//  Morse
//
//  Created by Tamerlan Satualdypov on 19.04.2022.
//

import SwiftUI

struct RoundedRect: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: .init(
                width: radius,
                height: radius
            )
        )
        
        return .init(path.cgPath)
    }
}
