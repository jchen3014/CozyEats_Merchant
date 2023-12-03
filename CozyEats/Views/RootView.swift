//
//  HomeView.swift
//  CozyEats
//
//  Created by Benjamin Melville on 10/9/23.
//

import SwiftUI

struct RootView: View {
    
    @State private var selection: Tab = .Home
    @State private var showSignInView: Bool = true
    @State private var userType: String = "customer"
    
    var body: some View {
        
        if showSignInView {
            AuthenticationView(showSignInView: $showSignInView, userType: $userType)
        } else if userType == "customer" {
            TabView(selection: $selection) {
                customerProfileViewTab
                customerHomeViewTab
                customerMapViewTab
            }
//            .tint(.primary)
        } else if userType == "seller" {
            TabView(selection: $selection) {
                sellerProfileViewTab
                sellerHomeViewTab
                sellerSettingsViewTab
            }
        }
    }
}



#Preview {
    RootView()
}



enum Tab: String {
    case Profile = "Profile"
    case Home = "Home"
    case Settings = "Settings"
}

extension RootView {
    
    private var customerProfileViewTab: some View {
        CustomerProfileView(showSignInView: $showSignInView)
            .tabItem {
                Label {
                    Text("Profile")
                } icon: {
                    Image(systemName: "person.fill")
                }
            }
            .tag(Tab.Profile)
    }
    
    private var customerHomeViewTab: some View {
        CustomerHomeView()
            .tabItem {
                Label {
                    Text("Home")
                } icon: {
                    Image(systemName: "house.fill")
                }
            }
            .tag(Tab.Home)
    }
    
    private var customerMapViewTab: some View {
        CustomerMapView()
            .tabItem {
                Label {
                    Text("Map")
                } icon: {
                    Image(systemName: "map")
                }
            }
            .tag(Tab.Settings)
    }
    
    
    
    
    private var sellerProfileViewTab: some View {
        SellerProfileView(showSignInView: $showSignInView)
            .tabItem {
                Label {
                    Text("Profile")
                } icon: {
                    Image(systemName: "person.fill")
                }
            }
            .tag(Tab.Profile)
    }
    
    private var sellerHomeViewTab: some View {
        SellerHomeView()
            .tabItem {
                Label {
                    Text("Home")
                } icon: {
                    Image(systemName: "house.fill")
                }
            }
            .tag(Tab.Home)
    }
    
    private var sellerSettingsViewTab: some View {
        SellerSettingsView()
            .tabItem {
                Label {
                    Text("Settings")
                } icon: {
                    Image(systemName: "gearshape.fill")
                }
            }
            .tag(Tab.Settings)
    }
}
