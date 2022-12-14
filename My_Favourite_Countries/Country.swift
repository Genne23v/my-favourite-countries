import Foundation

class Country: Identifiable, Decodable {
    
    var id = UUID()
    var name:String = ""
    var countryCode:String = ""
    var capital:String = ""
    var population:Int = 0
    var flagLink:String
    
    enum CodingKeys:String, CodingKey {
        case name
        case countryCode = "alpha3Code"
        case capital = "capital"
        case population
        case flag = "flags"
    }
    
    enum FlagKeys:String, CodingKey {
        case flagLink = "png"
    }
    
    required init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let flagContainer = try decoder.container(keyedBy: FlagKeys.self)
        
        name = try container.decode(String.self, forKey: CodingKeys.name)
        countryCode = try container.decode(String.self, forKey: CodingKeys.countryCode)
        capital = try container.decodeIfPresent(String.self, forKey: CodingKeys.capital) ?? "n/a"
        population = try container.decode(Int.self, forKey: CodingKeys.population)
        
        let flagNestedContainer = try container.nestedContainer(keyedBy: FlagKeys.self, forKey: .flag)
        flagLink = try flagNestedContainer.decode(String.self, forKey: FlagKeys.flagLink)
    }
}
