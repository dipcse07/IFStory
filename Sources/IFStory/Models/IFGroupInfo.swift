

import Foundation

public class IFGroupInfo: Codable {
    public var groupId:String?
    public var groupName:String?
    public var groupType:String?
    public var normalizedGroupName:String?
    public var privacyType:String?
    
    enum CodingKeys: String, CodingKey {
        case groupId = "groupId"
        case groupName = "groupName"
        case groupType = "groupType"
        case normalizedGroupName = "normalizedGroupName"
        case privacyType = "privacyType"
    }
}
