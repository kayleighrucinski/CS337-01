//
//  SchoolDetailViewController.swift
//  NJSchools


import UIKit

class SchoolDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var editedSchool: School?
    var editedCounty: String = ""
    
    var editedField: UITextField?
    
    @IBOutlet weak var schoolInfoTable: UITableView!
    
    @IBOutlet weak var ratingsSlider: UISlider!
    
    @IBOutlet weak var ratingsStars: UITextField!
    
    let schoolsModel = NJSchoolsModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        schoolInfoTable.dataSource = self
        schoolInfoTable.delegate = self
        initRatingsSlider(editedSchool!.properties.ratings)
        
        
        self.title = editedSchool?.properties.name
    }
    

    // tableview datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "schoolInfoCell", for: indexPath)
        
        switch (indexPath.row) {
        case 0:
            cell.textLabel?.text = "County:"
            cell.detailTextLabel?.text = editedSchool?.properties.county
            
        case 1:
            cell.textLabel?.text = "Address:"
            cell.detailTextLabel?.text = editedSchool?.properties.address
        case 2:
            cell.textLabel?.text = "Phone:"
            cell.detailTextLabel?.text = editedSchool?.properties.phoneNumber
        case 3:
            cell.textLabel?.text = "Rating:"
            cell.detailTextLabel?.text = String(editedSchool!.properties.ratings)
        default:
            cell.textLabel?.text = "???"
            cell.detailTextLabel?.text = "Data for Label ????"
        }
        return cell
    }

    func initRatingsSlider(_ rating: Int) {
        ratingsSlider.setValue(Float(rating), animated: true)
        showRatings(rating)
    }

    // Action method for UISlider
    
    @IBAction func setRatings(_ sender: UISlider) {
        print (ratingsSlider.value)
        sender.setValue(Float(lroundf(ratingsSlider.value)), animated: true)
        showRatings(Int(ratingsSlider.value))
    }
    func getStars (_ rating: Int) -> String {
        var s = " "
        if rating > 0 {
            for _ in 1...rating {
                s = s + "✴️"  // use of emoji
            }
        }
        return s
    }
    
    // update the rating the bottom view
    
    func showRatings(_ newRating: Int) {
        let s = getStars(newRating)
        print ("\(newRating)   \(s)")
        ratingsStars.text = s
    }

    func updateSchoolRating (_ newRating: Int) {
       let result = schoolsModel.updateSchoolRating(editedSchool!.properties.objectId, inCounty: editedCounty, rating: newRating)
        if result {
            showAlert("School rating has been updated")
        } else {
            showAlert("School rating has not been updated")
        }
    }
    
    // Construct an AlertControlle, its actions, and present
    
    func showAlert (_ messaage: String) {
        
        let alert = UIAlertController(title: "School Rating Data", message: messaage, preferredStyle: .alert)

        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            
            // if just to dismiss a VC, we can use
            // self.dismiss(animated: true, completion: nil)
            
            // But, we need to pop the VC since we are insde a NavigationContoller
            
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(ok)
        self.present(alert, animated: true)  // this will present the Alert
    }
    @IBAction func save(_ sender: Any) {
        updateSchoolRating(Int(ratingsSlider.value))
        
    }
} //end

