import SwiftUI

public struct EditEntryView: View {
    @State private var name: String
    @State private var assetTag: String
    var entry: Entry
    @ObservedObject var viewModel: AdminViewModel
    @Environment(\.presentationMode) var presentationMode

    public init(entry: Entry, viewModel: AdminViewModel) {
        self.entry = entry
        self.viewModel = viewModel
        _name = State(initialValue: entry.name)
        _assetTag = State(initialValue: entry.assetTag)
    }

    var body: some View {
        Form {
            TextField("Name", text: $name)
            TextField("Asset Tag", text: $assetTag)
            Button("Save") {
                viewModel.update(id: entry.id, name: name, assetTag: assetTag)
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationTitle("Edit Entry")
    }
}
