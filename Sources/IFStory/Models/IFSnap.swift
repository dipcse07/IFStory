
import Foundation

public enum StoryMimeType: String {
    case image
    case video
    case unknown
}
public class IFSnap: Codable {
    public let storySnapIdentifier: String
    public let mimeType: String
    public let lastUpdated: String
    public let storySnapUrl: String
	var isSeen = false
    public var kind: StoryMimeType {
        switch mimeType {
        case StoryMimeType.image.rawValue:
            return StoryMimeType.image
        case StoryMimeType.video.rawValue:
            return StoryMimeType.video
        default:
            return StoryMimeType.unknown
        }
    }
    enum CodingKeys: String, CodingKey {
        case storySnapIdentifier = "id"
        case mimeType = "mime_type"
        case lastUpdated = "last_updated"
        case storySnapUrl = "url"
		case isSeen = "is_seen"
    }
}
