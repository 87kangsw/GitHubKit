import Foundation

extension DecodingError {
    var debugDescription: String {
        switch self {
        case .typeMismatch(let key, let context):
            return "Type mismatch at \(context.codingPath.map { $0.stringValue }.joined(separator: ".")): expected \(key), but found different type. Context: \(context.debugDescription)"
        case .valueNotFound(let key, let context):
            return "Value not found at \(context.codingPath.map { $0.stringValue }.joined(separator: ".")): expected \(key). Context: \(context.debugDescription)"
        case .keyNotFound(let key, let context):
            return "Key '\(key.stringValue)' not found at \(context.codingPath.map { $0.stringValue }.joined(separator: ".")). Context: \(context.debugDescription)"
        case .dataCorrupted(let context):
            return "Data corrupted at \(context.codingPath.map { $0.stringValue }.joined(separator: ".")). Context: \(context.debugDescription)"
        @unknown default:
            return "Unknown decoding error: \(localizedDescription)"
        }
    }
}

extension JSONDecoder {
    static func debugDecode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            return try decoder.decode(type, from: data)
        } catch let decodingError as DecodingError {
            print("🚨 Decoding Error:")
            print(decodingError.debugDescription)

            // Print raw JSON for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 Raw JSON:")
                print(jsonString)
            }

            throw decodingError
        } catch {
            print("🚨 Unknown Error: \(error)")
            throw error
        }
    }
}