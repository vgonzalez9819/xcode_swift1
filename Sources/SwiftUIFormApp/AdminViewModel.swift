import Foundation
import Combine

final class AdminViewModel: ObservableObject {
    @Published var entries: [Entry] = []
    @Published var loggedIn: Bool = false

    func login(username: String, password: String) -> Bool {
        let success = DatabaseManager.shared.validateAdmin(username: username, password: password)
        if success {
            loggedIn = true
            fetch()
        }
        return success
    }

    func logout() {
        loggedIn = false
    }

    func fetch() {
        entries = DatabaseManager.shared.fetchEntries()
    }

    func delete(at offsets: IndexSet) {
        for index in offsets {
            let entry = entries[index]
            DatabaseManager.shared.deleteEntry(id: entry.id)
        }
        fetch()
    }

    func update(id: Int64, name: String, assetTag: String) {
        DatabaseManager.shared.updateEntry(id: id, name: name, assetTag: assetTag)
        fetch()
    }
}
