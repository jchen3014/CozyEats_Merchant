//
//  AuthenticationView.swift
//  CozyEats
//
//  Created by Benjamin Melville on 10/14/23.
//

import SwiftUI

struct AuthenticationView: View {
    
    @Binding var showSignInView: Bool
    @Binding var userType: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.tan.ignoresSafeArea()
                
                VStack() {
                    NavigationLink {
                        SignInWithEmailView(showSignInView: $showSignInView, userType: $userType)
                    } label: {
                        Text("sign in with email")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.primary)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.accent)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                            .padding(.bottom, 20)
                    }
                    
                    Text("Don't have an account?")
                    
                    NavigationLink {
                        SignUpWithEmailView(showSignInView: $showSignInView, userType: $userType)
                    } label: {
                        Text("sign up")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }

                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            .navigationTitle("Sign in")
        }
    }
}

#Preview {
    AuthenticationView(showSignInView: .constant(false), userType: .constant("customer"))
}
