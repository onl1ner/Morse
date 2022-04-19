//
//  View.swift
//  Morse
//
//  Created by Tamerlan Satualdypov on 18.04.2022.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        return self.clipShape(RoundedRect(radius: radius, corners: corners))
    }
    
    func readSize(completion: @escaping (CGSize) -> Void) -> some View {
        return self.background(
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        completion(geometry.size)
                    }
            }
        )
    }
    
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
