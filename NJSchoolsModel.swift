//
//  NJSchoolsModel.swift
//  NJSchools-Solution
//
//  Created by Kayleigh F. Rucinski on 10/21/21.
//
import Foundation

struct Geometry:Codable {
    var coordinates:[Double]
    enum CodingKeys: String, CodingKey {
        case coordinates="coordinates"
    }
} //end geometry
struct Properties: Codable {
    var objectId: Int
    var schoolType: String?
    var county: String
    var name: String
    var address: String?
    var city: String
    var phoneNumber: String?
    var ratings: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case objectId = "OBJECTID"
        case schoolType = "SOURCE"
        case county = "COUNTY"
        case name = "SCHOOLNAME"
        case address = "ADDRESS1"
        case city = "CITY"
        case phoneNumber = "PHONE"
    }
} //end properties
struct School:Codable {
    var properties: Properties
    var geometry: Geometry
}

// ********* MODEL CLASS *********
class NJSchoolsModel {
    static let sharedInstance = NJSchoolsModel()
    var njSchools:[School] = [] // array of school
    var njCountiesNschools:[String: [School]] = ["Atlantic" : [], "Bergen" : [], "Burlington" : [],"Camden" : [],
                      "Cape May": [], "Cumberland": [], "Essex": [], "Gloucester": [],
                      "Hudson": [], "Hunterdon": [], "Mercer": [], "Middlesex": [],
                      "Monmouth": [], "Morris": [], "Ocean": [],"Passaic": [],
                      "Salem": [], "Somerset": [], "Sussex": [], "Union": [],
                      "Warren": []]
    private init(){
      readSchoolsData()
      mapSchoolsToCounty()
    }
    
    func getSchools() -> [School] {
        return njSchools
    }
    
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
    } //end read schools data
    
    func mapSchoolsToCounty() {
        let counties = Array(njCountiesNschools.keys)
        for county in counties {
            njCountiesNschools[county] = njSchools.filter({($0.properties.county).caseInsensitiveCompare(county) == .orderedSame})
            njCountiesNschools[county]!.sort( by: {$0.properties.name < $1.properties.name})
        }
    } //end map schools to county
    
    func getSchoolInfo (forSchoolId objectId: Int, inCounty county: String ) -> School? {
        if let index = (njCountiesNschools[county])?.firstIndex(where: {$0.properties.objectId == objectId}) {
            return njCountiesNschools[county]?[index]
        }
        return nil;
    }
} // close NJSchoolsModel class
