import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var model: AppModel
    @State private var showingDeleteConfirmation = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Legal") {
                    Link("Privacy Policy", destination: model.configuration.privacyPolicyURL)
                    Link("Terms of Service", destination: model.configuration.termsURL)
                }

                Section("Support") {
                    if let supportEmailURL = model.configuration.supportEmailURL {
                        Link("Email Support", destination: supportEmailURL)
                    } else {
                        Text(model.configuration.supportEmail)
                    }
                }

                Section("Account") {
                    Button(role: .destructive) {
                        showingDeleteConfirmation = true
                    } label: {
                        Text("Delete My Account Data")
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Delete account data?", isPresented: $showingDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    model.deleteAccountData()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This removes saved items from this device.")
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppModel())
}
