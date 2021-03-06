import Core
import Multipart

/// Creates a multipart/form-data formatted array of bytes from Fields
/// suitable for an HTTP response or request body.
public final class Serializer {
    
    /// The underlying multipart serializer.
    /// Use to serialize preamble and epilogue.
    public let multipart: Multipart.Serializer
    
    public init(multipart: Multipart.Serializer) {
        self.multipart = multipart
    }
    
    /// This method serializes an entire Field.
    ///
    /// This may be called as many times as needed.
    ///
    /// After all Field have been serialized,
    /// `finish()` must be called on the multipart serializer
    /// to add the closing boundary.
    ///
    /// Fields can obviously not be serialized after the
    /// epilogue has been serialized.
    public func serialize(_ field: Field) throws {
        var part = field.part
        
        var contentDisposition = "form-data; name=\"\(field.name)\""
        
        if let filename = field.filename {
            contentDisposition += "; filename=\"\(filename)\""
        }
        
        part.headers["Content-Disposition"] = contentDisposition
        try multipart.serialize(part)
    }
    
    /// Generates a Content-Type header value from a boundary
    public static func generateContentType(boundary: BytesConvertible) throws -> Bytes {
        let b = try boundary.makeBytes()
        return  "multipart/form-data; boundary=".makeBytes() + b
    }
}
