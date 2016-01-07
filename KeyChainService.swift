import UIKit
import Security

// Identifiers
let userAccount = "github"
let accessGroup = "MySerivice"

// Arguments for the keychain queries
let kSecClassValue = kSecClass as NSString
let kSecAttrAccountValue = kSecAttrAccount as NSString
let kSecValueDataValue = kSecValueData as NSString
let kSecClassGenericPasswordValue = kSecClassInternetPassword as NSString
let kSecAttrServiceValue = kSecAttrService as NSString
let kSecMatchLimitValue = kSecMatchLimit as NSString
let kSecReturnDataValue = kSecReturnData as NSString
let kSecMatchLimitOneValue = kSecMatchLimitOne as NSString

class KeychainService: NSObject {

 class func saveToken(token: NSString) {
    self.save(token)
  }
  
  class func loadToken() -> NSString? {
    let token = self.loadFromKeychain()
    
    return token
  }

  private class func save(data: NSString) {
    let dataFromString: NSData = data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    
    let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, userAccount, dataFromString], forKeys: [kSecClassValue, kSecAttrAccountValue, kSecValueDataValue])
    
    SecItemDelete(keychainQuery)
    
    var status: OSStatus = SecItemAdd(keychainQuery, nil)
  }
  
  private class func loadFromKeychain() -> NSString? {
    
    let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, userAccount, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
    
    let dataTypeRef :Unmanaged<AnyObject>?
    
    let status: OSStatus = SecItemCopyMatching(keychainQuery, dataTypeRef)
    
    var contentsOfKeychain: NSString?
    
    if let retainedData = dataTypeRef?.takeRetainedValue() as? NSData {
      contentsOfKeychain = NSString(data: retainedData, encoding: NSUTF8StringEncoding)
    } else {
      print("Nothing was retrieved from the keychain. Status code \(status)")
    }
    dataTypeRef?.release()
    return contentsOfKeychain
  }
}