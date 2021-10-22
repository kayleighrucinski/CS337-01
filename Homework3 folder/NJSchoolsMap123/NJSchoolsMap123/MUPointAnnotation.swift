//
//  MUPointAnnotation.swift
//  NJSchoolsMap123
//
//  Created by Kayleigh F. Rucinski on 10/21/21.
//

import UIKit
import MapKit

class MUPointAnnotation: MKPointAnnotation {
    var pinTintColor: UIColor?
    var id:Int = 0
    var type:AnnotationTypes = AnnotationTypes.school
}
