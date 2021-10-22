//
//  CustomSchoolTableViewCell.swift
//  NJSchoolsMap123
//
//  Created by Kayleigh F. Rucinski on 10/22/21.
//

import UIKit

class CustomSchoolTableViewCell: UITableViewCell {

    @IBOutlet weak var ratings: UILabel!
    @IBOutlet weak var county: UILabel!
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var schoolTypeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
