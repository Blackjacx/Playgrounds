import Foundation

public enum Result<SuccessType, ErrorType: Error> {
    case failure(_ error: ErrorType)
    case success(_ value: SuccessType)
}
