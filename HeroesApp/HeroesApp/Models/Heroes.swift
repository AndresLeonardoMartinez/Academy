import Foundation
import CoreData

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}

protocol EntityNameable {
    static func entityName() -> String
}


class ResponseHeroes: NSManagedObject, Decodable, CodableHasContextChecker, EntityNameable {
    @NSManaged var code: Int32
    @NSManaged var status: String//, copyright, attributionText, attributionHTML: String
    //  @NSManaged var etag: String
    @NSManaged var data: DataClassHeroes
    
    enum CodingKeys: String, CodingKey{
        case code
        case status
        case data
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let ent = ResponseHeroes.hasValidContext(decoder: decoder, entityName: "ResponseHeroes") else {
            fatalError("Failed to decode Subject!")
        }
        self.init(entity: ent.0, insertInto: ent.1)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(Int32.self, forKey: .code)
        self.status = try container.decode(String.self, forKey: .status)
        self.data = try container.decode(DataClassHeroes.self, forKey: .data)
    }
    
    static func entityName() -> String {
        return "ResponseHeroes"
    }
}


class DataClassHeroes: NSManagedObject, Decodable, CodableHasContextChecker {
    @NSManaged var offset, limit, total, count: Int32
    @NSManaged var results: Set<Heroe>
    enum CodingKeys: String, CodingKey{
        case offset
        case limit
        case total
        case count
        case results
    }
    required convenience init(from decoder: Decoder) throws {
        guard let ent = DataClassHeroes.hasValidContext(decoder: decoder, entityName: "DataClassHeroes") else {
            fatalError("Failed to decode Subject!")
        }
        self.init(entity: ent.0, insertInto: ent.1)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.offset = try container.decode(Int32.self, forKey: .offset)
        self.limit = try container.decode(Int32.self, forKey: .limit)
        self.total = try container.decode(Int32.self, forKey: .total)
        self.count = try container.decode(Int32.self, forKey: .count)
        self.results = try container.decode(Set<Heroe>.self, forKey: .results)
        
        
    }
}

class Heroe: NSManagedObject, Codable, CodableHasContextChecker {
    @NSManaged var id: Int32
    @NSManaged var name, descriptionHeroe: String
    //@NSManaged var modified: Date
    @NSManaged var thumbnail: Thumbnail
    // @NSManaged var resourceURI: String
    //@NSManaged var comics, series: Comics
    //  @NSManaged var stories: Stories
    // @NSManaged var events: Comics
    // @NSManaged var urls: [URLElement]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case descriptionHeroe = "description"
        case thumbnail
    }
    
//    init(id: Int, name: String, description: String, thumbnail: Thumbnail ){
//        self.id = Int32(id)
//        self.name = name
//        self.descriptionHeroe = description
//        self.thumbnail = thumbnail
//        
//    }
    required convenience init(from decoder: Decoder) throws {
        guard let ent = Heroe.hasValidContext(decoder: decoder, entityName: "Heroe") else {
            fatalError("Failed to decode Subject!")
        }
        self.init(entity: ent.0, insertInto: ent.1)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int32.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.descriptionHeroe = try container.decode(String.self, forKey: .descriptionHeroe)
        self.thumbnail = try container.decode(Thumbnail.self, forKey: .thumbnail)
        
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(descriptionHeroe, forKey: .descriptionHeroe)
        try container.encode(thumbnail, forKey: .thumbnail)
        
    }
    
}

enum URLType: String {
    case detail
    case comilink
    case wiki
    case unknown
}

class URLElement: NSManagedObject, Decodable, CodableHasContextChecker {
    @NSManaged private var type: String
    @NSManaged var url: String
    
    var realType: URLType {
        return URLType(rawValue: self.type) ?? .unknown
    }
    
    enum CodingKeys: String, CodingKey{
        case type
        case url
    }
    required convenience init(from decoder: Decoder) throws {
        guard let ent = Heroe.hasValidContext(decoder: decoder, entityName: "URLElement") else {
            fatalError("Failed to decode Subject!")
        }
        self.init(entity: ent.0, insertInto: ent.1)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        self.url = try container.decode(String.self, forKey: .url)

    }
    
}



