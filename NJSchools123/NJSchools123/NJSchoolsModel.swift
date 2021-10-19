//
//  NJSchoolsModel.swift
//  NJSchools
//
//  Created by Kayleigh F. Rucinski on 10/1/21.
//
import Foundation

struct Geometry:Codable {
    var coordinates:[Double]
    enum CodingKeys: String, CodingKey {
        case coordinates="coordinates"
    }
}
// struct and property for "Property" key in JSON
struct Properties: Codable {
    var objectId: Int
    var schoolType: String?
    var county: String
    var name: String
    var ratings: Int = 0
    var address: String?
    var phoneNumber: String?
    
    
    
enum CodingKeys: String, CodingKey {
    case objectId = "OBJECTID"
    case schoolType = "SOURCE"
    case county = "COUNTY"
    case name = "SCHOOLNAME"
    case address = "ADDRESS1"
    case phoneNumber = "PHONE"
    }
}
// struct for School. Note these refer the above two
struct School:Codable {
    var properties: Properties
    var geometry: Geometry
}
class NJSchoolsModel {
    // singleton variable for instantiated object
    
    static let sharedInstance = NJSchoolsModel()
    
    
    var njSchools:[School] = [] // array of school
    // Dictionary with counties as keys and array of Schools as value
    var njCountiesNschools:[String: [School]] = ["Atlantic" : [], "Bergen" : [], "Burlington" : [],"Camden" : [],
                      "Cape May": [], "Cumberland": [], "Essex": [], "Gloucester": [],
                      "Hudson": [], "Hunterdon": [], "Mercer": [], "Middlesex": [],
                      "Monmouth": [], "Morris": [], "Ocean": [],"Passaic": [],
                      "Salem": [], "Somerset": [], "Sussex": [], "Union": [],
                      "Warren": []]
     // constructor method
    private init(){
      readSchoolsData()
      mapSchoolsToCounty()
    }
    
    // 1. read the JSON file as string.
    // 2. convert string to data using UTF8 characters
    // 3. decode the data as an array of School structs.
    // 4. we nee wrap inside do try block and catch in case there is an error in above
    //    steps
    
    func readSchoolsData() {
        if let filename = Bundle.main.path(forResource: "NJSchools", ofType: "json") {
            do {
                let jsonStr = try String(contentsOfFile: filename)
                let jsonData = jsonStr.data(using: .utf8)!
                njSchools = try JSONDecoder().decode([School].self, from: jsonData)
            } catch {
                print("The file could not be loaded")
            }
        }
    }
    func mapSchoolsToCounty() {
        let counties = Array(njCountiesNschools.keys) // get county names as an array of String from the dictionary
        
        // filter the school with county name and map the filtered list to
        //    each counties array of Schools. Use case insenstive comparison
        
        for county in counties {
            njCountiesNschools[county] = njSchools.filter({($0.properties.county).caseInsensitiveCompare(county) == .orderedSame})
        }
    }
    func updateSchoolRating (_ schoolID: Int, inCounty county: String, rating new: Int) -> Bool {
            let countySchools = njCountiesNschools[county]!
            let countySchoolIndex = countySchools.firstIndex(where: {$0.properties.objectId == schoolID} )
            njCountiesNschools[county]![countySchoolIndex!].properties.ratings = new
            return true
    }
}


