

import Foundation

public class IFSingleStory: Codable {
    // Note: To retain lastPlayedSnapIndex value for each story making this type as class
    public var totalSnapInStory: Int
    public var snaps: [IFSnap]?
    public var storyIdentifier: String
    public var lastUpdated: String
    public var user: IFUser
    public var isSeen = false
    public var storyType: String?
    public var group: IFGroupInfo?
    public var institute: IFInstitute?
    public var lastShowedSnapIndex = 0
    public var isWholeStoryViewed = false
    public var isCancelledSuddenly = false
    
    enum CodingKeys: String, CodingKey {
        case totalSnapInStory = "snaps_count"
        case snaps = "snaps"
        case storyIdentifier = "id"
        case lastUpdated = "last_updated"
        case user = "user"
        case isSeen = "is_seen"
        case storyType = "story_type"
        case group = "group"
        case institute = "insitute"
    }
}

extension IFSingleStory: Equatable {
    public static func == (lhs: IFSingleStory, rhs: IFSingleStory) -> Bool {
        return lhs.storyIdentifier == rhs.storyIdentifier
    }
}
