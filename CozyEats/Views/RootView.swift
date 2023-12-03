import SwiftUI

struct RootView: View {
    
    @State private var selection: Tab = .Home
    @State private var showSignInView: Bool = true
    @State private var userType: String = "seller"
    
    var body: some View {
        
        if showSignInView {
            AuthenticationView(showSignInView: $showSignInView, userType: $userType)
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
