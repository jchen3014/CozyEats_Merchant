//
//  FoodPreviewView.swift
//  CozyEats
//
//  Created by Benjamin Melville on 10/10/23.
//

import SwiftUI

@MainActor
final class FeedCellViewModel: ObservableObject {
    @Published private(set) var image: UIImage? = nil
    
    func loadMenuImage(imageUrl: String) async throws {
        let data = try await StorageManager.shared.getImage(imageUrl: imageUrl)
        self.image = UIImage(data: data)
    }
    
    
    
}





struct FeedCellView: View {
    
    @StateObject private var viewModel = FeedCellViewModel()
    
    @State var isLiked: Bool = false
    @State var showSheet: Bool = false
    
    let seller: Seller
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            VStack {
                FeedCellHeaderView(seller: seller)
                    .padding(.bottom, 12)
                    .padding(.horizontal, 8)
                
                
                
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 400, height: 400)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 12.0))
                        .overlay(alignment: .topTrailing) {
                            VStack {
                                if let cuisine = seller.menu?.first?.cuisine {
                                    Text(cuisine)
                                        .font(.system(.footnote, design: .serif))
                                        .foregroundStyle(.black)
                                        .fontWeight(.semibold)
                                        .padding(4)
                                }
                                
                            }
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .padding(.top)
                            .padding(.trailing)
                        }
                        .overlay(alignment: .bottomLeading) {
                            
                            Button {
                                showSheet.toggle()
                                
                            } label: {
                                HStack {
                                    Text("$\(seller.menu?.first?.price?.description ?? "n/a")").foregroundColor(.black.opacity(0.6)) +
                                    Text(" order here")
                                        .foregroundColor(.black)

                                }
                                .font(.system(.title2, design: .serif))
                                .fontWeight(.semibold)
                                .frame(height: 50)
                                .padding(.horizontal)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 12.0))
                                .padding(.bottom)
                                .padding(.leading)
                            }
                            .sheet(isPresented: $showSheet) {
                                if let menu = seller.menu {
                                    OrderView(menuItem: menu.first!, seller: seller)
                                }
                            }


                        }

                    
                    
                } else {
                    
                    ProgressView()
                        .frame(width: 400, height: 400)

//                    Text("NO IMAGE")
//                        .frame(width: 400, height: 400)
                }
                //            Image("\(seller.menu?.first?.images.first ?? "lasagna")")
                //                .resizable()
                //                .scaledToFill()
                //                .frame(height: 400)
            }
            
            
            HStack {
                Text("34 likes")
                    .font(.system(.footnote, design: .serif))
                    .fontWeight(.semibold)
                    .onTapGesture {
                        print("liked image")
                    }
                
                Spacer()
                
                Text("15 comments")
                    .font(.system(.footnote, design: .serif))
                    .foregroundStyle(.secondary)
                    .onTapGesture {
                        print("comments")
                    }
            }
            .frame(height: 16)
            .padding(.vertical, 14)
            .padding(.horizontal, 8)
            
            Divider()
                .padding(.horizontal, 8)
            
            
            FeedCellActionBar()
            
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 3)
            
                .foregroundStyle(.secondary.opacity(0.6))
                .ignoresSafeArea()
            
        }
        .task {
            try? await viewModel.loadMenuImage(imageUrl: seller.menu?.first?.images.first ?? "")
        }
        
        
        
        
        
        //        VStack {
        //            HStack {
        //
        //                Image(systemName: "person.circle")
        //                    .resizable()
        //                    .scaledToFit()
        //                    .frame(width: 35, height: 35)
        //
        //                Text("Ben Melville")
        //                    .font(.headline)
        //                Spacer()
        //                Image(systemName: "ellipsis")
        //
        //            }
        ////            .foregroundStyle(Color("lightPink"))
        //            .padding(.horizontal)
        //
        //            Image("lasagna")
        //                .resizable()
        //                .frame(height: 350)
        //                .scaledToFit()
        //
        //            HStack(spacing: 15) {
        //                Image(systemName: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
        //                    .resizable()
        //                    .scaledToFit()
        //                    .frame(width: 25, height: 25)
        //                    .foregroundStyle(isLiked ? Color("isLiked") : Color.primary)
        //                    .onTapGesture {
        //                        withAnimation(.bouncy) {
        //                            isLiked.toggle()
        //                        }
        //                    }
        //                Image(systemName: "text.bubble")
        //                    .resizable()
        //                    .scaledToFit()
        //                    .frame(width: 25, height: 25)
        //
        //                Spacer()
        //
        //                FiveStarsView()
        //            }
        //            .padding(.horizontal)
        //            .font(.headline)
        //
        //        }
        
        
    }
}

#Preview {
    FeedCellView(seller: Seller(firstName: "bruce", lastName: "wayne", userId: "asdfouyastasdfv", dateCreated: Date(), email: "batman@gmail.com", photoUrl: "", menu: nil))
}
