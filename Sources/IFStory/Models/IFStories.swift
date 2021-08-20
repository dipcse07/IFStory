

import Foundation

public class IFStories: Codable {
	public let flag: Bool
    public let totalStoryCount: Int
    public var stories: [IFSingleStory]
    
    enum CodingKeys: String, CodingKey {
		case flag = "flag"
        case totalStoryCount = "total"
        case stories = "content"
    }
    func copy() throws -> IFStories {
        let data = try JSONEncoder().encode(self)
        let copy = try JSONDecoder().decode(IFStories.self, from: data)
        return copy
    }
}
