//
//  SignInWithEmailView.swift
//  CozyEats
//
//  Created by Benjamin Melville on 10/14/23.
//

import SwiftUI

struct SignInWithEmailView: View {
    
    @StateObject private var viewModel = SignInWithEmailViewModel()
    @State private var showingAlert = false
    @State private var loginSuccessful: Bool = false
    @Binding var showSignInView: Bool
    @Binding var userType: String
    
    var body: some View {
        ZStack {
            
            Color.tan.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Group {
                    TextField("Enter email...", text: $viewModel.email)
                    SecureField("Enter password...", text: $viewModel.password)
                }
                .font(.headline)
                .padding(.leading)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))

                
                Button {
                    Task {
                        do {
                            userType = try await viewModel.signIn()
                            print(userType)
                            if userType == "customer" || userType == "seller" {
                                withAnimation {
                                    showSignInView = !showSignInView
                                }
                            } else {
                                showingAlert = true
                            }
                        } catch {
                            showingAlert = true
                            print(error)
                        }
                    }
                } label: {
                    Text("sign in")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.primary)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        .shadow(radius: 10)
                }
                .alert("Error incorrect email or password", isPresented: $showingAlert) {
                    Button(role: .cancel) {
                        showingAlert = false
                    } label: {
                        Text("try again")
                    }
                }
                
 

                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationTitle("Sign in with email")
    }
}

#Preview {
    NavigationStack {
        SignInWithEmailView(showSignInView: .constant(false), userType: .constant("customer"))
    }
}
