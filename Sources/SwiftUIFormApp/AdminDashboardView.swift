import SwiftUI

public struct AdminDashboardView: View {
    @ObservedObject var viewModel: AdminViewModel
    public init(viewModel: AdminViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.entries) { entry in
                    NavigationLink(destination: EditEntryView(entry: entry, viewModel: viewModel)) {
                        VStack(alignment: .leading) {
                            Text(entry.name)
                            Text(entry.assetTag)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete { indexSet in
                    viewModel.delete(at: indexSet)
                }
            }
            .navigationTitle("Submissions")
            .navigationBarItems(trailing: Button("Logout") { viewModel.logout() })
        }
    }
}
