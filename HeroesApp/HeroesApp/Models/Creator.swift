import Foundation
import CoreData

class ResponseCreator: NSManagedObject, Decodable, CodableHasContextChecker , EntityNameable {
    static func entityName() -> String {
        return "ResponseCreator"
    }
    @NSManaged var code: Int32
    @NSManaged var status: String
    @NSManaged var data: DataClassCreator
    enum CodingKeys: String, CodingKey{
        case code
        case status
        case data
    }
    required convenience init(from decoder: Decoder) throws {
        guard let ent = ResponseHeroes.hasValidContext(decoder: decoder, entityName: "ResponseCreator") else {
            fatalError("Failed to decode Subject!")
        }
        self.init(entity: ent.0, insertInto: ent.1)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(Int32.self, forKey: .code)
        self.status = try container.decode(String.self, forKey: .status)
        self.data = try container.decode(DataClassCreator.self, forKey: .data)
    }
    
}

class DataClassCreator: NSManagedObject, Decodable, CodableHasContextChecker  {
    @NSManaged var offset, limit, total, count: Int32
    @NSManaged var results: Set<Creator>
    enum CodingKeys: String, CodingKey{
        case offset
        case limit
        case total
        case count
        case results
    }
    required convenience init(from decoder: Decoder) throws {
        guard let ent = DataClassHeroes.hasValidContext(decoder: decoder, entityName: "DataClassCreator") else {
            fatalError("Failed to decode Subject!")
        }
        self.init(entity: ent.0, insertInto: ent.1)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.offset = try container.decode(Int32.self, forKey: .offset)
        self.limit = try container.decode(Int32.self, forKey: .limit)
        self.total = try container.decode(Int32.self, forKey: .total)
        self.count = try container.decode(Int32.self, forKey: .count)
        self.results = try container.decode(Set<Creator>.self, forKey: .results)
        
        
    }
    
}

class Creator: NSManagedObject, Decodable, CodableHasContextChecker  {
    @NSManaged var id: Int32
    @NSManaged var fullName: String
    @NSManaged var thumbnail: Thumbnail
    @NSManaged var urls: Set<URLElement>
    enum CodingKeys: String, CodingKey{
        case id
        case fullName
        case thumbnail
        case urls
    }
    required convenience init(from decoder: Decoder) throws {
        guard let ent = DataClassHeroes.hasValidContext(decoder: decoder, entityName: "Creator") else {
            fatalError("Failed to decode Subject!")
        }
        self.init(entity: ent.0, insertInto: ent.1)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int32.self, forKey: .id)
        self.fullName = try container.decode(String.self, forKey: .fullName)
         self.thumbnail = try container.decode(Thumbnail.self, forKey: .thumbnail)
        self.urls = try container.decode(Set<URLElement>.self, forKey: .urls)

        
    }
    
}

//struct Comics: NSManagedObject, Decodable, CodableHasContextChecker {
//    @NSManaged var available: Int32
//    @NSManaged var collectionURI: String
//    @NSManaged var items: [ComicsItem]
//    @NSManaged var returned: Int32
//}

//struct ComicsItem: NSManagedObject, Decodable, CodableHasContextChecker {
//    @NSManaged var resourceURI: String
//    @NSManaged var name: String
//}
//
//struct Stories: NSManagedObject, Decodable, CodableHasContextChecker {
//    @NSManaged var available: Int32
//    @NSManaged var collectionURI: String
//    @NSManaged var items: [StoriesItem]
//    @NSManaged var returned: Int32
//}
//
//struct StoriesItem: NSManagedObject, Decodable, CodableHasContextChecker {
//    @NSManaged var resourceURI: String
//    @NSManaged var name: String
//    @NSManaged var type: ItemType
//}
//
//enum ItemType: String, Codable {
//    case cover = "cover"
//    case empty = ""
//    case interiorStory = "interiorStory"
//    case pinup
//    case unknown
//}
//extension ItemType {
//    public init(from decoder: Decoder) throws {
//        self = try ItemType(rawValue: decoder.singleValueContainer().decode(String.self)) ?? .unknown
//    }
//}

class Thumbnail: NSManagedObject, Codable, CodableHasContextChecker {
    @NSManaged var path: String
    @NSManaged var thumbnailExtension: String
    
    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let ent = Thumbnail.hasValidContext(decoder: decoder, entityName: "Thumbnail") else {
            fatalError("Failed to decode Subject!")
        }
        
        self.init(entity: ent.0, insertInto: ent.1)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.path = try container.decode(String.self, forKey: .path)
        self.thumbnailExtension = try container.decode(String.self, forKey: .thumbnailExtension)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(path, forKey: .path)
        try container.encode(thumbnailExtension, forKey: .thumbnailExtension)
        
    }
}

//enum Extension: String, Codable {
//    case jpg
//    case gif
//    case png
//}


