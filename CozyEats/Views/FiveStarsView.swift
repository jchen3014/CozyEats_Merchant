//
//  FiveStarsView.swift
//  CozyEats
//
//  Created by Benjamin Melville on 10/11/23.
//

import SwiftUI

struct FiveStarsView: View {
    
    @State var rating: Int = 1
    
    var body: some View {
        ZStack {
            starsView.overlay(overlayView.mask(starsView))
        }
    }
}

#Preview {
    FiveStarsView()
}

extension FiveStarsView {
    
    private var starsView: some View {
        HStack {
            ForEach(1..<6) { index in
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(Color.gray)
                    .onTapGesture {
                        withAnimation(.smooth) {
                            rating = index
                        }
                    }
            }
        }
    }
    
    private var overlayView: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundStyle(.yellow)
                    .frame(width: CGFloat(rating) / 5 * geometry.size.width)
            }
        }
        .allowsHitTesting(false)
    }
    
    
    
    
}
