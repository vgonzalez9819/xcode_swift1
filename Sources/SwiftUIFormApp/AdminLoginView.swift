import SwiftUI

struct AdminLoginView: View {
    @StateObject private var adminVM = AdminViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var failed = false

    var body: some View {
        if adminVM.loggedIn {
            AdminDashboardView(viewModel: adminVM)
        } else {
            NavigationView {
                Form {
                    TextField("Username", text: $username)
                    SecureField("Password", text: $password)
                    if failed {
                        Text("Invalid credentials").foregroundColor(.red)
                    }
                    Button("Login") {
                        failed = !adminVM.login(username: username, password: password)
                    }
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.secondary)
                }
                .navigationTitle("Admin Login")
            }
        }
    }
}
