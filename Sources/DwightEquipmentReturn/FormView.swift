import SwiftUI

struct FormView: View {
    @StateObject private var viewModel = FormViewModel()

    var body: some View {
        Form {
            Section(header: Text("Dwight Equipment Return").font(.largeTitle).bold()) {
                TextField("Asset Tag of Laptop", text: $viewModel.laptopAssetTag)
                TextField("Asset Tag If Not Correct", text: $viewModel.correctedAssetTag)
                Picker("Charger Returned?", selection: $viewModel.chargerReturnedSelection) {
                    Text("Yes").tag(Optional(true))
                    Text("No").tag(Optional(false))
                }
                .pickerStyle(SegmentedPickerStyle())
                Picker("Yondr Pouch Returned?", selection: $viewModel.yondrReturnedSelection) {
                    Text("Yes").tag(Optional(true))
                    Text("No").tag(Optional(false))
                }
                .pickerStyle(SegmentedPickerStyle())
                if viewModel.chargerReturnedSelection == false {
                    TextEditor(text: $viewModel.chargerReason)
                        .frame(minHeight: 80)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
                        .padding(.vertical, 4)
                        .accessibility(label: Text("Reason for not returning charger"))
                }
                if viewModel.yondrReturnedSelection == false {
                    TextEditor(text: $viewModel.yondrReason)
                        .frame(minHeight: 80)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
                        .padding(.vertical, 4)
                        .accessibility(label: Text("Reason for not returning Yondr pouch"))
                }
                TextEditor(text: $viewModel.damageNotes)
                    .frame(minHeight: 80)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
                    .padding(.vertical, 4)
                    .accessibility(label: Text("Laptop Damage Inspection Notes"))

                Button("Submit") { viewModel.submit() }
            }
            if !viewModel.entries.isEmpty {
                Section(header: Text("Past Submissions")) {
                    ForEach(viewModel.entries) { entry in
                        VStack(alignment: .leading) {
                            Text(entry.laptopAssetTag).bold()
                            if let corrected = entry.correctedAssetTag { Text("Corrected Asset Tag: \(corrected)") }
                            Text("Charger Returned: \(entry.chargerReturned ? "Yes" : "No")")
                            if let r = entry.chargerReason { Text("Charger Reason: \(r)") }
                            Text("Yondr Returned: \(entry.yondrReturned ? "Yes" : "No")")
                            if let r = entry.yondrReason { Text("Yondr Reason: \(r)") }
                            if let d = entry.damageNotes { Text("Damage Notes: \(d)") }
                        }
                    }
                }
            }
        }
        .alert(isPresented: $viewModel.showConfirmation) {
            Alert(title: Text("Submission received. Thank you!"))
        }
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView()
    }
}
