import Foundation

enum ParsingError: Error, LocalizedError {

    case jsonNotFound
    case failedToGetJsonData
    case failedToParseJson

    var errorDescription: String? {
        switch self {
        case .jsonNotFound: return "JSON not found."
        case .failedToGetJsonData: return "Failed to get JSON data."
        case .failedToParseJson: return "Failed to parse json."
        }
    }

}
