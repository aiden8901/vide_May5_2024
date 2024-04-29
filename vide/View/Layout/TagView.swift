//
//  TagView.swift
//  EventApp
//
//  Created by Ahmadreza on 10/15/21.
//  Copyright © 2021 Alexani. All rights reserved.
//

import SwiftUI

struct TagView: View {
    @Binding var selectedTag: String
    @State var tags: [String]
    @State private var totalHeight = CGFloat.zero       // << variant for ScrollView/List //    = CGFloat.infinity   // << variant for VStack
    var randomColors: [(foreground: Color, background: Color)] {
        var colors: [(foreground: Color, background: Color)] = []
        for _ in tags.indices {
            let backgroundColor = Color.random
            let foregroundColor = backgroundColor.isDark ? Color.white : Color.black
            colors.append((foregroundColor, backgroundColor))
        }
        return colors
    }
    
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)// << variant for ScrollView/List
        //.frame(maxHeight: totalHeight) // << variant for VStack
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        return ZStack(alignment: .topLeading) {
            ForEach(tags.indices) { index in
                
                item(for: tags[index], index: index)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if tags[index] == self.tags.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if tags[index] == self.tags.last! {
                            height = 0 // last item
                        }
                        return result
                    }).onTapGesture {
                        selectedTag = tags[index]
                    }
            }
        }.background(viewHeightReader($totalHeight))
    }
    
    private func item(for text: String, index: Int) -> some View {
        Text(text)
            .foregroundColor(randomColors[index].foreground)
            .padding()
            .lineLimit(1)
            .background(randomColors[index].background)
            .frame(height: 36)
            .cornerRadius(18)
            .overlay(Capsule().stroke(.blue, lineWidth: 1))
        
    }
    
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}
