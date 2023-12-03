//
//  FeedCellActionBar.swift
//  Workouts
//
//  Created by Benjamin Melville on 11/2/23.
//

import SwiftUI

struct FeedCellActionBar: View {
    
    @State var isLiked: Bool = false

    var body: some View {
        HStack {
            Button {
                withAnimation(.spring) {
                    isLiked.toggle()
                }
            } label: {
                Label {
                    Text("like")
                } icon: {
                    Image(systemName: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .imageScale(.large)
                        .foregroundStyle(isLiked ? Color.green : Color.secondary)
                }
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Label {
                    Text("comment")
                } icon: {
                    Image(systemName: "text.bubble")
                        .imageScale(.large)
                }


            }
            
            Spacer()
            
            Button {
                
            } label: {
                Label {
                    Text("share")
                } icon: {
                    Image(systemName: "square.and.arrow.up")
                        .imageScale(.large)
                }


            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 55)
        .font(.system(.subheadline, design: .serif))
        .foregroundStyle(Color.secondary)
        .padding(.horizontal, 8)


    }
}

#Preview {
    FeedCellActionBar()
}
