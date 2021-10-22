//
//  SchoolsListTableViewController.swift
//  NJ Schools
//
//  Created by Kayleigh F. Rucinski 
//

import UIKit

class SchoolsListableViewController: UITableViewController {
    
    let schoolsModel = NJSchoolsModel.sharedInstance
    var njCountiesSorted:[String] = []
    
    let schoolCellReuseIdentifier = "schoolCell"  // identifier for TableViewCell
    let detailSegue = "detailSegue" // segue identifier
    
    var selectedIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        njCountiesSorted = Array(schoolsModel.njCountiesNschools.keys).sorted()
        tableView.register(UINib(nibName: String(describing: CustomSchoolTableViewCell.self), bundle: nil), forCellReuseIdentifier: schoolCellReuseIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        self.title = "NJ K-12 Schools"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let reloadIndexPath = selectedIndexPath {
            tableView.reloadRows(at: [reloadIndexPath], with: .fade)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        njCountiesSorted.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schoolsModel.njCountiesNschools[njCountiesSorted[section]]!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: schoolCellReuseIdentifier, for: indexPath) as! CustomSchoolTableViewCell
        let school = schoolsModel.njCountiesNschools[njCountiesSorted[indexPath.section]]![indexPath.row]

        // Configure the cell...
        
        // three UILabel views
        
        cell.schoolName?.text = school.properties.name
        cell.county?.text = school.properties.city
        
        cell.ratings?.text = "Ratings: " + getStars(school.properties.ratings)
        
        // image view
        if let stype = school.properties.schoolType {
            // image view
            switch (stype) {
            case "CHARTER":
                cell.schoolTypeImage?.image = UIImage(named: "charter")
            case "PUBLIC":
                cell.schoolTypeImage?.image = UIImage(named: "public")
            case "PRIVATE":
                cell.schoolTypeImage?.image = UIImage(named: "private")
            default:
                cell.schoolTypeImage?.image = UIImage(systemName: "questionmark.square.dashed")
                
            }
        } else {
            cell.schoolTypeImage?.image = UIImage(systemName: "questionmark.square.dashed")
        }

        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let totalShools = " - Total Schools: " +  String(schoolsModel.njCountiesNschools[njCountiesSorted[section]]!.count)
        return njCountiesSorted[section] + totalShools
    }
    
    // this shows the Section pickers to right of the table
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return njCountiesSorted  // we just need to return the section header data
    }

    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: detailSegue, sender: self)
    }
    
    // MARK: -  Methods
    
    // return the number of emoji stars
    
    func getStars (_ rating: Int) -> String {
        return String (repeating: "⭐", count: rating)  // use of emoji
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.00
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "detailSegue") {
            let dvc = segue.destination as! SchoolDetaiViewController
            dvc.editedSchool = schoolsModel.getSchoolInfo(forSchoolId: schoolsModel.njCountiesNschools[njCountiesSorted[selectedIndexPath!.section]]![selectedIndexPath!.row].properties.objectId, inCounty: njCountiesSorted[selectedIndexPath!.section])
        }
    }
     
    

}
