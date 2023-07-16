import Foundation

struct AnyEncodable: Encodable {
    var value: Any?

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch value {
        case is ExpressibleByNilLiteral:
            try container.encodeNil()
        case let value as String:
            try container.encode(value)
        case let value as Int:
            try container.encode(value)
        case let value as Double:
            try container.encode(value)
        case let value as Bool:
            try container.encode(value)
        case nil:
            try container.encodeNil()
        default:
            let context = EncodingError.Context(
                codingPath: container.codingPath,
                debugDescription: "Unsupported type"
            )
            throw EncodingError.invalidValue(value as Any, context)
        }
    }
}
