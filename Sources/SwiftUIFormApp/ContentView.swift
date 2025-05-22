import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = EntryViewModel()
    @State private var name: String = ""
    @State private var assetTag: String = ""
    @State private var showAdmin = false

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Submit")) {
                        TextField("Name", text: $name)
                        TextField("Asset Tag", text: $assetTag)
                        Button("Submit") {
                            viewModel.addEntry(name: name, assetTag: assetTag)
                            name = ""
                            assetTag = ""
                        }
                    }
                }
                List(viewModel.entries) { entry in
                    VStack(alignment: .leading) {
                        Text(entry.name)
                        Text(entry.assetTag)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Form")
            .navigationBarItems(trailing: Button("Admin") { showAdmin = true })
            .sheet(isPresented: $showAdmin) {
                AdminLoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
