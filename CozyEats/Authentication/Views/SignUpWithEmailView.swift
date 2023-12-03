//
//  SignUpWithEmailView.swift
//  CozyEats
//
//  Created by Benjamin Melville on 10/15/23.
//

import SwiftUI


//enum UserType: String {
//    case customer = "customer"
//    case seller = "seller"
//}

@MainActor
final class SignUpWithEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var userType = ""
    
    // TODO: Add alert and functionality to check user is already in the system
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("no email or password found.")
            return
        }
        
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        
        if userType == "customer" {
            let user = Customer(auth: authDataResult, firstName: firstName, lastName: lastName)
            try await CustomerManager.shared.createNewCustomer(user: user)
            
        } else if userType == "seller" {
            let user = Seller(auth: authDataResult, firstName: firstName, lastName: lastName)
            try await SellerManager.shared.createNewSeller(user: user)

        }
        
    }
}

struct SignUpWithEmailView: View {
    
    @StateObject private var viewModel = SignUpWithEmailViewModel()
    @Binding var showSignInView: Bool
    @State var userTypeSelection = "customer"
    @Binding var userType: String
    
    let userTypeOptions = ["customer", "seller"]
    
    var body: some View {
        ZStack {
            
            Color.tan.ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Group {
                    TextField("first name...", text: $viewModel.firstName)
                    TextField("last name...", text: $viewModel.lastName)
                    TextField("email...", text: $viewModel.email)
                    SecureField("password...", text: $viewModel.password)
                }
                .font(.headline)
                .padding(.leading)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                
                
                Picker("", selection: $userTypeSelection) {
                    ForEach(userTypeOptions, id: \.self) { option in
                        Text(option)
                            .tag(option)
                    }
                }
                .pickerStyle(.segmented)

                
                Button {
                    Task {
                        do {
                            viewModel.userType = userTypeSelection
                            userType = viewModel.userType
                            try await viewModel.signUp()
                            
                            withAnimation(.easeInOut) {
                                showSignInView = !showSignInView
                            
                                return
                            }
                            
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("sign up")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.primary)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                }
                
                Spacer()

            }
            .padding(.horizontal)
        }
        .navigationTitle("Sign up")
    }
}

#Preview {
    NavigationStack {
        SignUpWithEmailView(showSignInView: .constant(false), userType: .constant("customer"))
    }
}
