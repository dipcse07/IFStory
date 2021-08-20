

import Foundation

public class IFSingleStory: Codable {
    // Note: To retain lastPlayedSnapIndex value for each story making this type as class
    public var totalSnapInStory: Int
    public var snapsInSingleStory: [IFSnap]?
    public var storyIdentifier: String
    public var lastUpdated: String
    public var user: IFUser
	var isSeen = false
	var storyType: String?
	public var group: IFGroupInfo?
	public var institute: IFInstitute?
    var lastShowedSnapIndex = 0
    var isWholeStoryViewed = false
    var isCancelledSuddenly = false
    
    enum CodingKeys: String, CodingKey {
        case totalSnapInStory = "snaps_count"
        case snapsInSingleStory = "snaps"
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
