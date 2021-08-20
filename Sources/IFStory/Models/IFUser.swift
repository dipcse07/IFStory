
import Foundation

public class IFUser: Codable {
    public let userIdentifier: String
    public let userName: String
    public let userProfilePicture: String
    
    enum CodingKeys: String, CodingKey {
        case userIdentifier = "id"
        case userName = "name"
        case userProfilePicture = "picture"
    }
}
