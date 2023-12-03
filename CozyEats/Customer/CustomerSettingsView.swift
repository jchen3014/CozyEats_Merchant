import SwiftUI

struct CustomerContentView: View {
    var body: some View {
        NavigationView {
            CustomerSettingsView()
        }
    }
}

struct CustomerSettingsView: View {
    @State private var newUsername = ""
    @State private var newPassword = ""
    @State private var newEmail = ""
    @State private var userFeedback = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Customer Settings")
                .font(.system(.largeTitle, design: .serif))
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            Text("Change Username:")
                .font(.system(.headline, design: .serif))
                .padding(.top, 10)
            
            TextField("Enter new username", text: $newUsername)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(.headline, design: .serif))


            Text("Change Email:")
                .font(.system(.headline, design: .serif))
                .padding(.top, 10)
            TextField("Enter new email", text: $newEmail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(.headline, design: .serif))


            Text("Change Password:")
                .font(.system(.headline, design: .serif))
                .padding(.top, 10)
            SecureField("Enter new password", text: $newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(.headline, design: .serif))


            Spacer()
            Divider()

            // Section for User Feedback
            VStack(alignment: .leading, spacing: 10) {
                Text("Add Any Comments/Suggestions Below:")
                    .font(.system(.headline, design: .serif))
                    .fontWeight(.semibold)
                    .padding(.top, 10)
                
                TextField("Enter your feedback", text: $userFeedback)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(.headline, design: .serif))

            }

            Spacer()
        }
        .background(.tan)
    }
}

struct CustomerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerSettingsView()
    }
}
