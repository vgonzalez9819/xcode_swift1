import Foundation
import SQLite3

final class DatabaseManager {
    static let shared = DatabaseManager()
    private let db: OpaquePointer?

    private init() {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let url = urls[0].appendingPathComponent("formapp.db")
        var pointer: OpaquePointer? = nil
        if sqlite3_open(url.path, &pointer) != SQLITE_OK {
            db = nil
            return
        }
        db = pointer
        createTables()
        insertDefaultAdmin()
    }

    deinit {
        if let db = db {
            sqlite3_close(db)
        }
    }

    private func createTables() {
        let createEntries = "CREATE TABLE IF NOT EXISTS entries(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, assetTag TEXT);"
        sqlite3_exec(db, createEntries, nil, nil, nil)
        let createAdmins = "CREATE TABLE IF NOT EXISTS admins(username TEXT PRIMARY KEY, password TEXT);"
        sqlite3_exec(db, createAdmins, nil, nil, nil)
    }

    private func insertDefaultAdmin() {
        let query = "INSERT OR IGNORE INTO admins(username, password) VALUES('admin', '$uper@dmin');"
        sqlite3_exec(db, query, nil, nil, nil)
    }

    func insertEntry(name: String, assetTag: String) {
        let sql = "INSERT INTO entries(name, assetTag) VALUES(?, ?);"
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, name, -1, nil)
            sqlite3_bind_text(stmt, 2, assetTag, -1, nil)
            sqlite3_step(stmt)
        }
        sqlite3_finalize(stmt)
    }

    func fetchEntries() -> [Entry] {
        let sql = "SELECT id, name, assetTag FROM entries ORDER BY id DESC;"
        var stmt: OpaquePointer?
        var results: [Entry] = []
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let id = sqlite3_column_int64(stmt, 0)
                guard let nameC = sqlite3_column_text(stmt, 1),
                      let assetC = sqlite3_column_text(stmt, 2) else { continue }
                let name = String(cString: nameC)
                let asset = String(cString: assetC)
                results.append(Entry(id: id, name: name, assetTag: asset))
            }
        }
        sqlite3_finalize(stmt)
        return results
    }

    func updateEntry(id: Int64, name: String, assetTag: String) {
        let sql = "UPDATE entries SET name = ?, assetTag = ? WHERE id = ?;"
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, name, -1, nil)
            sqlite3_bind_text(stmt, 2, assetTag, -1, nil)
            sqlite3_bind_int64(stmt, 3, id)
            sqlite3_step(stmt)
        }
        sqlite3_finalize(stmt)
    }

    func deleteEntry(id: Int64) {
        let sql = "DELETE FROM entries WHERE id = ?;"
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_int64(stmt, 1, id)
            sqlite3_step(stmt)
        }
        sqlite3_finalize(stmt)
    }

    func validateAdmin(username: String, password: String) -> Bool {
        let sql = "SELECT COUNT(*) FROM admins WHERE username = ? AND password = ?;"
        var stmt: OpaquePointer?
        var result = false
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, username, -1, nil)
            sqlite3_bind_text(stmt, 2, password, -1, nil)
            if sqlite3_step(stmt) == SQLITE_ROW {
                result = sqlite3_column_int(stmt, 0) > 0
            }
        }
        sqlite3_finalize(stmt)
        return result
    }
}
