import Foundation
import Combine

final class EntryViewModel: ObservableObject {
    @Published var entries: [Entry] = []

    init() {
        fetch()
    }

    func fetch() {
        entries = DatabaseManager.shared.fetchEntries()
    }

    func addEntry(name: String, assetTag: String) {
        DatabaseManager.shared.insertEntry(name: name, assetTag: assetTag)
        fetch()
    }
}
