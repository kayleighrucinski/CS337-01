//
//  SchoolsListTableViewController.swift
//  NJSchools
//
//  Created by Kayleigh F. Rucinski on 10/1/21.
//

import UIKit

class SchoolsListTableViewController: UITableViewController {
    
    let schoolsModel = NJSchoolsModel.sharedInstance
    var njCountiesSorted:[String] = []

    let schoolCellReuseIdentifier = "newSchoolCell"
    
    var selectedIndexPath: IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//        print (schoolsModel.njSchools.count)
//
//        for (county,schools) in schoolsModel.njCountiesNschools {
//            print (county)
//            print (schools.count)
//        }
        
      
        
        njCountiesSorted = Array(schoolsModel.njCountiesNschools.keys).sorted()
        
        tableView.rowHeight  = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        self.title = "NJ Counties and Schools"
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let redoSchoolInfo = selectedIndexPath {
            tableView.reloadRows(at: [redoSchoolInfo], with:.fade)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return schoolsModel.njCountiesNschools.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let county = njCountiesSorted[section]
        
        return schoolsModel.njCountiesNschools[county]?.count  ?? 0
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: schoolCellReuseIdentifier, for: indexPath) as! NewSchoolsDataTableViewCell
        
        let county = njCountiesSorted[indexPath.section]
        
        if let countySchools = schoolsModel.njCountiesNschools[county] {
            cell.nameLabel.text = countySchools[indexPath.row].properties.name
            cell.ratingsLabel.text = String(countySchools[indexPath.row].properties.ratings)
            cell.phoneLabel.text = countySchools[indexPath.row].properties.phoneNumber
            
            switch
            countySchools[indexPath.row].properties.schoolType
            {
            case "CHARTER":
                cell.schoolImage.image = UIImage(named: "charter")
            case "PUBLIC":
                cell.schoolImage.image = UIImage(named: "public")
            case "PRIVATE":
                cell.schoolImage.image = UIImage(named: "private")
            default:
                cell.schoolImage.image = UIImage(systemName: "questionmark.square.dashed")
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return njCountiesSorted[section]
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let county = njCountiesSorted[section]
        
        let totalSchools = schoolsModel.njCountiesNschools[county]?.count  ?? 0
        return "Total School: \(totalSchools)"
    }
    
    // MARK: - Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("\(indexPath.section)    \(indexPath.row)")
        selectedIndexPath = indexPath
        
        performSegue(withIdentifier: "detailSegue", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let validIndexPath = selectedIndexPath {
            
            // get me the school for selected indexpath - section and row
            // ???
           let county = njCountiesSorted[validIndexPath.section]
           let school = schoolsModel.njCountiesNschools[county]![validIndexPath.row]
            print (school)
            
            
            
            if segue.identifier == "detailSegue" {
                // get hold of the destination and send the school info
                let destinationViewController = segue.destination as! SchoolDetailViewController
                destinationViewController.editedSchool = school
                destinationViewController.editedCounty = county
            }
        }
    }
    

}
