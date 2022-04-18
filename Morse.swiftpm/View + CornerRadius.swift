//
//  View + CornerRadius.swift
//  Morse
//
//  Created by Tamerlan Satualdypov on 18.04.2022.
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

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        return self.clipShape(RoundedRect(radius: radius, corners: corners))
    }
}
