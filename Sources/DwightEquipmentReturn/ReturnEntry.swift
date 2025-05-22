import Foundation

struct ReturnEntry: Identifiable, Codable {
    let id = UUID()
    var laptopAssetTag: String
    var correctedAssetTag: String?
    var chargerReturned: Bool
    var chargerReason: String?
    var yondrReturned: Bool
    var yondrReason: String?
    var damageNotes: String?
}
