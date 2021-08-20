
import Foundation

public class IFInstitute: Codable {
	public let imageURL: String?
	public let instituteId: String
	public let instituteName: String?
	public let instituteAccronym: String?
	
	enum CodingKeys: String, CodingKey {
		case imageURL = "imageURL"
		case instituteId = "instituteId"
		case instituteName = "instituteName"
		case instituteAccronym = "abbreviation"
	}
}
