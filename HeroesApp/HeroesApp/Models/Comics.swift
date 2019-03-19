import Foundation
import CoreData

class ResponseComic: NSManagedObject, Decodable, CodableHasContextChecker, EntityNameable {
    static func entityName() -> String {
        return "ResponseComic"
    }
    
    @NSManaged var code: Int32
    @NSManaged var status: String
    @NSManaged var data: DataClassComic
    
    enum CodingKeys: String, CodingKey{
        case code
        case status
        case data
    }
    required convenience init(from decoder: Decoder) throws {
        guard let ent = ResponseHeroes.hasValidContext(decoder: decoder, entityName: "ResponseComic") else {
            fatalError("Failed to decode Subject!")
        }
        self.init(entity: ent.0, insertInto: ent.1)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(Int32.self, forKey: .code)
        self.status = try container.decode(String.self, forKey: .status)
        self.data = try container.decode(DataClassComic.self, forKey: .data)
    }
 
}

class DataClassComic: NSManagedObject, Decodable, CodableHasContextChecker {
    @NSManaged var offset, limit, total, count: Int32
    @NSManaged var results: Set<Comic>
    enum CodingKeys: String, CodingKey{
        case offset
        case limit
        case total
        case count
        case results
    }
    required convenience init(from decoder: Decoder) throws {
        guard let ent = DataClassHeroes.hasValidContext(decoder: decoder, entityName: "DataClassComic") else {
            fatalError("Failed to decode Subject!")
        }
        self.init(entity: ent.0, insertInto: ent.1)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.offset = try container.decode(Int32.self, forKey: .offset)
        self.limit = try container.decode(Int32.self, forKey: .limit)
        self.total = try container.decode(Int32.self, forKey: .total)
        self.count = try container.decode(Int32.self, forKey: .count)
        self.results = try container.decode(Set<Comic>.self, forKey: .results)
        
        
    }
    
    
}

class Comic: NSManagedObject, Decodable, CodableHasContextChecker {
    @NSManaged var id:Int32
    @NSManaged var title: String
    @NSManaged var descriptionComic: String?
    @NSManaged var resourceURI: String
    @NSManaged var thumbnail: Thumbnail
    
    enum CodingKeys: String, CodingKey{
        case id
        case title
        case descriptionComic = "description"
        case resourceURI
        case thumbnail
    }
    required convenience init(from decoder: Decoder) throws {
        guard let ent = Heroe.hasValidContext(decoder: decoder, entityName: "Comic") else {
            fatalError("Failed to decode Subject!")
        }
        self.init(entity: ent.0, insertInto: ent.1)
        let container = try decoder.container(keyedBy: CodingKeys.self)
         self.id = try container.decode(Int32.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.descriptionComic = try container.decode(Optional.self, forKey: .descriptionComic)
           self.thumbnail = try container.decode(Thumbnail.self, forKey: .thumbnail)
    
}

//class Characters: NSManagedObject, Decodable, CodableHasContextChecker {
//    @NSManaged var available: Int32
//    @NSManaged var collectionURI: String
//    @NSManaged var items: [Series]
//    @NSManaged var returned: Int32
//}

//class Series: NSManagedObject, Decodable, CodableHasContextChecker {
//    @NSManaged var resourceURI: String
//    @NSManaged var name: String
//}
//
//class Creators: NSManagedObject, Decodable, CodableHasContextChecker {
//    @NSManaged var available: Int32
//    @NSManaged var collectionURI: String
//    @NSManaged var items: [CreatorsItem]
//    @NSManaged var returned: Int32
//}
//
//class CreatorsItem: NSManagedObject, Decodable, CodableHasContextChecker {
//    @NSManaged var resourceURI: String
//    @NSManaged var name, role: String
//}



//
//enum ModifiedEnum: String, Codable {
//    case the00011130T0000000500 = "-0001-11-30T00:00:00-0500"
//}
//
//enum DateType: String, Codable {
//    case focDate = "focDate"
//    case onsaleDate = "onsaleDate"
//    case unlimitedDate = "unlimitedDate"
//}

//enum Format: String, Codable {
//    case comic = "Comic"
//    case digitalComic = "Digital Comic"
//    case tradePaperback = "Trade Paperback"
//}
//
//
//enum Isbn: String, Codable {
//    case empty = ""
//    case the0785111298 = "0-7851-1129-8"
//}
//
//class Price: NSManagedObject, Decodable, CodableHasContextChecker {
//    @NSManaged var type: PriceType
//    @NSManaged var price: Double
//}

//enum PriceType: String, Codable {
//    case prInt32Price = "prInt32Price"
//}
//
//class TextObject: NSManagedObject, Decodable, CodableHasContextChecker {
//    @NSManaged var type, language, text: String
}
//
