//
//  SchoolDetaiViewController.swift
//  NJSchools-Solution
//
//  Created by RamanLakshmanan on 10/16/21.
//

import UIKit

class SchoolDetaiViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // outlets to views
    
    @IBOutlet weak var schoolInfo: UITableView!
    @IBOutlet weak var ratingsStars: UITextField!
    @IBOutlet weak var ratingsSlider: UISlider!
    
    // identifier for data cell
    let schoolCellReuseIdentifier = "schoolDataCell"
    
    // Model reference and data for the object
    
    let schoolsModel = NJSchoolsModel.sharedInstance
    var editedSchool: School?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = editedSchool?.properties.name
        
        self.schoolInfo.dataSource = self
        self.schoolInfo.delegate = self
        initRatingsSlider(editedSchool!.properties.ratings)
    }
    
    // we are going to show 5 properties, 1 per row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    // one section in our tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // set the cell textLabel, detailTextLabel, and image
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: schoolCellReuseIdentifier, for: indexPath)

        switch (indexPath.row) {
        case 0:
            cell.textLabel?.text = "Address"
            cell.detailTextLabel?.text = editedSchool?.properties.address
        case 1:
            cell.textLabel?.text = "City"
            cell.detailTextLabel?.text = editedSchool?.properties.city
        case 2:
            cell.textLabel?.text = "Phone Number"
            cell.detailTextLabel?.text = editedSchool?.properties.phoneNumber
        case 3:
            cell.textLabel?.text = "Ratings"
            cell.detailTextLabel?.text = getStars(editedSchool!.properties.ratings)
        case 4:
            cell.textLabel?.text = "School Type"
            cell.detailTextLabel?.text = editedSchool?.properties.schoolType
        default:
            cell.textLabel?.text = "???"
            cell.detailTextLabel?.text = "???"
        }
        return cell
    }
    
    
    // MARK: - Class Methods
    
    // returns the ratings as star emoji string
    
    func getStars (_ rating: Int) -> String {
        return String(repeating: "⭐️", count: rating)
    }
    
    // set the slider position
    
    func initRatingsSlider(_ rating: Int) {
        ratingsSlider.setValue(Float(rating), animated: true)
        showRatings(rating)
    }

    // Action method for UISlider
    
    @IBAction func setRatings(_ sender: UISlider) {
        let roundedUp = ratingsSlider.value.rounded(.up)
        sender.setValue(roundedUp, animated: true)
        showRatings(Int(roundedUp))
        editedSchool!.properties.ratings = Int(roundedUp)
        self.schoolInfo.reloadData()
    }

    
    // update the ratings the bottom view
    
    func showRatings(_ newRating: Int) {
        let s = getStars(newRating)
        ratingsStars.text = s
    }
    
    
    // MARK: - Methods for save and alers
    
    // Action from Barbutton save
    
    @IBAction func save(_ sender: Any) {
        
        // get rating
        let enteredRating = Int(ratingsSlider.value)
        
        // invoke models update method
        
        let updateResult = schoolsModel.updateSchoolsRating(forSchoolId: editedSchool!.properties.objectId, county: editedSchool!.properties.county.capitalized, rating: enteredRating)
        
        // Alert setup
        
        if (updateResult) {
            showAlert("Updated!!")
        } else {
            showAlert ("Not Updated")
        }
    }
    
    // Construct an AlertControlle, its actions, and present
    
    func showAlert (_ messaage: String) {
        
        let alert = UIAlertController(title: "School Data", message: messaage, preferredStyle: .alert)

        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(ok)
        self.present(alert, animated: true)  // this will present the Alert
    }
}
