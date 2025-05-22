import Foundation
import Combine

public final class EntryViewModel: ObservableObject {
    @Published var entries: [Entry] = []

    public init() {
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
