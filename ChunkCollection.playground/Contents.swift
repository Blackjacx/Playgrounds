import UIKit

extension Collection {
    func chunked(by maxLength: Int) -> [SubSequence] {
        precondition(maxLength > 0, "chunk size must be greater than zero")
        var start = startIndex
        return stride(from: 0, to: count, by: maxLength).map { _ in
            let end = index(start, offsetBy: maxLength, limitedBy: endIndex) ?? endIndex
            defer { start = end }
            return self[start..<end]
        }
    }
}

[1, 2, 3, 4, 5, 6, 7, 8].chunked(by: 2)

"Hello World ABC".chunked(by: 2)
