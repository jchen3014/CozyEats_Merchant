//
//  ShoppingCartView.swift
//  CozyEats
//
//  Created by Benjamin Melville on 11/10/23.
//

import SwiftUI


@MainActor
final class ShoppingCartViewModel: ObservableObject {
    
    
    @Published private(set) var user: Customer? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        
        self.user = try await CustomerManager.shared.getCustomer(userId: authDataResult.uid)
    }
}

struct ShoppingCartView: View {
    
    @StateObject var viewModel = ShoppingCartViewModel()
    @State var total = 0
    
    var body: some View {
        
        VStack {
            List {
                if let user = viewModel.user, let cart = user.cart {
                    
                    ForEach(cart, id: \.self) { menuItem in
                        HStack {
                            Text(menuItem.name)
                            Spacer()
                            if let price = menuItem.price, let quantity = menuItem.quantity {
                                Text("$\(price * quantity)")
                            }
                        }
                    }
                    .onDelete(perform: delete)
                    
                }
            }
            
            Divider()
            
            if let user = viewModel.user, let cart = user.cart {
                Text("total: $\(computeTotal(cart: cart))")
                    .font(.system(.title2, design: .serif))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)

            }
            
            Divider()
            
            NavigationLink {
                //TODO: purchase items
                PaymentView()
            } label: {
                Text("place order")
                    .font(.system(.title2, design: .serif))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .foregroundStyle(.white)
                    .background(.green)
                    .clipShape(RoundedRectangle(cornerRadius: 12.0))
                    .padding(.horizontal, 8)
            }
            
            Spacer()

            

        }
        .navigationTitle("Your Shopping Cart")
        .task {
            try? await viewModel.loadCurrentUser()
        }
        
    }
    
    func computeTotal(cart: [MenuItem]) -> Int {
        var total = 0
        for item in cart {
            if let price = item.price, let quantity = item.quantity {
                total += price * quantity
            }
            print(total)
        }
        return total
    }
    
    func delete(indexSet: IndexSet) {
        
    }
}

#Preview {
    NavigationStack {
        ShoppingCartView()
    }
}
