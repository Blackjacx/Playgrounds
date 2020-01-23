import Foundation
import CryptoKit

let key = SymmetricKey(size: .bits256)
let plain = """
    {"data":{"id":"7fab123e96","created_at":"2020-01-21T14:16:41Z","name":"John","age":18,"sex":"male"}}
    """

/// Encrypt: Using plain text only • nonce & tag are randomly created
/// Decrypt: Specify all 3 parameters: nonce + cipher text + tag
func cryptoDemoCipherText() {

    // Encrypt
    let sealedBox = try! AES.GCM.seal(plain.data(using: .utf8)!, using: key)

    // Decrypt
    let sealedBoxRestored = try! AES.GCM.SealedBox(nonce: sealedBox.nonce, ciphertext: sealedBox.ciphertext, tag: sealedBox.tag)
    let decrypted = try! AES.GCM.open(sealedBoxRestored, using: key)

    print("Crypto Demo I\n••••••••••••••••••••••••••••••••••••••••••••••••••\n")
    print("Combined:\n\(sealedBox.combined!.base64EncodedString())\n")
    print("Cipher:\n\(sealedBox.ciphertext.base64EncodedString())\n")
    print("Nonce:\n\(sealedBox.nonce.withUnsafeBytes { Data(Array($0)).base64EncodedString() })\n")
    print("Tag:\n\(sealedBox.tag.base64EncodedString())\n")
    print("Decrypted:\n\(String(data: decrypted, encoding: .utf8)!)\n")
}

/// Encrypt: Specify all 3 parameters yourself: nonce + cipher text + tag
/// Decrypt: Using combined data (nonce + cipher text + tag) and tag to open
func cryptoDemoCombinedData() {

    let nonce = try! AES.GCM.Nonce(data: Data(base64Encoded: "fv1nixTVoYpSvpdA")!)
    let tag = Data(base64Encoded: "e1eIgoB4+lA/j3KDHhY4BQ==")!

    // Encrypt
    let sealedBox = try! AES.GCM.seal(plain.data(using: .utf8)!, using: key, nonce: nonce, authenticating: tag)

    // Decrypt
    let sealedBoxRestored = try! AES.GCM.SealedBox(combined: sealedBox.combined!)
    let decrypted = try! AES.GCM.open(sealedBoxRestored, using: key, authenticating: tag)

    print("Crypto Demo II\n••••••••••••••••••••••••••••••••••••••••••••••••••\n")
    print("Combined:\n\(sealedBox.combined!.base64EncodedString())\n")
    print("Cipher:\n\(sealedBox.ciphertext.base64EncodedString())\n")
    print("Nonce:\n\(nonce.withUnsafeBytes { Data(Array($0)).base64EncodedString() })\n")
    print("Tag:\n\(tag.base64EncodedString())\n")
    print("Decrypted:\n\(String(data: decrypted, encoding: .utf8)!)\n")
}


print("Key32:\n\(key.withUnsafeBytes { Data(Array($0)).base64EncodedString() })\n")

cryptoDemoCombinedData()
cryptoDemoCipherText()
