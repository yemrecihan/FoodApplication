import Foundation

class TranslationHelper {
    static func translate(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
