import Foundation
import UIKit
import MapKit
import Contacts


class SchoolAnnotation: NSObject, MKAnnotation {
 
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var pinTintColor: UIColor?
    var schoolID: Int
    var type = AnnotationTypes.school

    init (latitude: CLLocationDegrees, longitude: CLLocationDegrees, title: String, subTitle: String, schoolID id: Int) {
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.title = title
        self.subtitle = subTitle
        schoolID = id
    }
    func mapItem() -> MKMapItem {
        let destinationTitle = title! + ", " + subtitle!
        let addrDict = [CNPostalAddressCityKey: destinationTitle]
        let placemark = MKPlacemark (coordinate: coordinate, addressDictionary: addrDict)
        let mapItem = MKMapItem (placemark: placemark)
        return mapItem
    } //end map item
} //end school annotation
