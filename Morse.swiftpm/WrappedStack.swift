//
//  WrappedStack.swift
//  Morse
//
//  Created by Tamerlan Satualdypov on 20.04.2022.
//

import SwiftUI

struct WrappedStack<Data: RandomAccessCollection, Content: View>: View {
    @State private var totalHeight: CGFloat = 0.0
    
    private let source: Data
    
    private let itemSpacing: CGFloat
    private let lineSpacing: CGFloat
    
    private let content: (Data.Element) -> Content
    
    public init(
        itemSpacing: CGFloat = 8.0,
        lineSpacing: CGFloat = 8.0,
        source: Data,
        content: @escaping (Data.Element) -> Content
    ) {
        self.source = source
        
        self.itemSpacing = itemSpacing
        self.lineSpacing = lineSpacing
        
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { geometry in
            self.content(in: geometry)
        }
        .frame(height: self.totalHeight)
    }
    
    @ViewBuilder
    private func content(in geometry: GeometryProxy) -> some View {
        var width: CGFloat = 0.0
        var height: CGFloat = 0.0
        
        ZStack(alignment: .topLeading) {
            ForEach(Array(source.enumerated()), id: \.offset) { index, element in
                self.content(element)
                    .padding(.trailing, self.itemSpacing)
                    .padding(.vertical, self.lineSpacing / 2.0)
                    .alignmentGuide(.leading) { dimension -> CGFloat in
                        if abs(width - dimension.width) > geometry.size.width {
                            width = 0.0
                            height -= dimension.height
                        }
                        
                        let result = width
                        
                        if index == self.source.count - 1 {
                            width = 0.0
                        } else {
                            width -= dimension.width
                        }
                        
                        return result
                    }
                    .alignmentGuide(.top) { _ in
                        let result = height
                        
                        if index == self.source.count - 1 {
                            height = 0.0
                        }
                        
                        return result
                    }
            }
        }
        .readSize { size in
            self.totalHeight = size.height
        }
    }
}
