import Foundation
import Combine

final class FormViewModel: ObservableObject {
    @Published var laptopAssetTag: String = ""
    @Published var correctedAssetTag: String = ""
    @Published var chargerReturnedSelection: Bool? = nil
    @Published var yondrReturnedSelection: Bool? = nil
    @Published var chargerReason: String = ""
    @Published var yondrReason: String = ""
    @Published var damageNotes: String = ""
    @Published var entries: [ReturnEntry] = []
    @Published var showConfirmation: Bool = false

    var chargerReturned: Bool { chargerReturnedSelection == true }
    var yondrReturned: Bool { yondrReturnedSelection == true }

    func submit() {
        guard validate() else { return }
        let entry = ReturnEntry(
            laptopAssetTag: laptopAssetTag,
            correctedAssetTag: correctedAssetTag.isEmpty ? nil : correctedAssetTag,
            chargerReturned: chargerReturned,
            chargerReason: chargerReturned ? nil : chargerReason,
            yondrReturned: yondrReturned,
            yondrReason: yondrReturned ? nil : yondrReason,
            damageNotes: damageNotes.isEmpty ? nil : damageNotes
        )
        entries.append(entry)
        resetForm()
        showConfirmation = true
    }

    func validate() -> Bool {
        return !laptopAssetTag.isEmpty && chargerReturnedSelection != nil && yondrReturnedSelection != nil
    }

    func resetForm() {
        laptopAssetTag = ""
        correctedAssetTag = ""
        chargerReturnedSelection = nil
        yondrReturnedSelection = nil
        chargerReason = ""
        yondrReason = ""
        damageNotes = ""
    }
}
