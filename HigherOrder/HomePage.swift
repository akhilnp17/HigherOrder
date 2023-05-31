//
//  ViewController.swift
//  HigherOrder
//
//  Created by AKHIL N P on 25/05/23.
//

import UIKit

class HomePage: UIViewController, EditAndAdd {

    @IBOutlet weak var arrowBtn: UIButton!
    
    @IBOutlet weak var nameBtnRef: UIButton!
    
    @IBOutlet weak var emailBtnRef: UIButton!
    
    @IBOutlet weak var IDBtnRef: UIButton!
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tbl: UITableView!
    var val = false
    var change = ""
    
    var items : [String: [[String: Any]]] = [
        "Employee_details": [
            [
                "name": "Amal",
                "email": "amalll18@gmail.com",
                "Emp_id": 90
            ],
            [
                "name": "Vidhya",
                "email": "vidhya@gmail.com",
                "Emp_id": 3
            ],
            [
                "name": "Radha",
                "email": "radhika@gmail.com",
                "Emp_id": 91
            ],
            [
                "name": "Akhil",
                "email": "amalllf18@gmail.com",
                "Emp_id": 91
            ],
            [
                "name": "Asad",
                "email": "aml18@gmail.com",
                "Emp_id": 66
            ]
        ]
    ]

    var items1 : [String: [[String: Any]]] = [:]
    var items2 : [String: [[String: Any]]] = [:]
    var searchResults : [[String: Any]] = []
    var name1 = ""
    var email1 = ""
    var empID1 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items1 = items

        searchField.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tbl.reloadData()
        
    }

    @IBAction func addBtn(_ sender: UIButton) {
        change = "Add"
        let strybrd = UIStoryboard(name: "Main", bundle: nil)
        let vc = strybrd.instantiateViewController(withIdentifier: "add")as!AddDetailsViewController
       
        vc.changeMadeDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func searchBtn(_ sender: Any) {
        
    }
    
    @IBAction func acendAndDesend(_ sender: UIButton) {
        
        if nameBtnRef.isSelected == true || emailBtnRef.isSelected == true || IDBtnRef.isSelected == true{
            sender.isSelected = !sender.isSelected
        }
        
        
        if nameBtnRef.isSelected == true{
            if sender.isSelected{
                items1 = items1.mapValues { $0.sorted { ($0["name"] as? String ?? "").localizedCaseInsensitiveCompare($1["name"] as? String ?? "") == .orderedDescending } }
                tbl.reloadData()
            }else{
                items1 = items1.mapValues { $0.sorted { ($0["name"] as? String ?? "").localizedCaseInsensitiveCompare($1["name"] as? String ?? "") == .orderedAscending } }
                tbl.reloadData()
            }
        }else if emailBtnRef.isSelected == true{
            if sender.isSelected{
                items1 = items1.mapValues { $0.sorted { ($0["email"] as? String ?? "").localizedCaseInsensitiveCompare($1["email"] as? String ?? "") == .orderedDescending } }
                tbl.reloadData()
            }else{
                items1 = items1.mapValues { $0.sorted { ($0["email"] as? String ?? "").localizedCaseInsensitiveCompare($1["email"] as? String ?? "") == .orderedAscending } }
                tbl.reloadData()
            }
        }else if IDBtnRef.isSelected == true{
            if sender.isSelected{
                
                items1 = items1.mapValues { $0.sorted { ($0["Emp_id"] as? Int ?? 0) < ($1["Emp_id"] as? Int ?? 0)} }
                tbl.reloadData()
                
            }else{
                items1 = items1.mapValues { $0.sorted { ($0["Emp_id"] as? Int ?? 0) > ($1["Emp_id"] as? Int ?? 0)} }
                tbl.reloadData()
            }
        }
         
    }
    
    @IBAction func nameFilt(_ sender: UIButton) {
        arrowBtn.isSelected = false
        emailBtnRef.isSelected = false
        IDBtnRef.isSelected = false
        searchField.isHidden = false
     //   sender.isSelected = !sender.isSelected
        sender.isSelected = true
        
        if sender.isSelected{
            items1 = items1.mapValues { $0.sorted { ($0["name"] as? String ?? "").localizedCaseInsensitiveCompare($1["name"] as? String ?? "") == .orderedAscending } }
            tbl.reloadData()
            searchField.placeholder = "Search Name here"
        }

    }
    
    @IBAction func emailFilt(_ sender: UIButton) {
        
        arrowBtn.isSelected = false
        nameBtnRef.isSelected = false
        IDBtnRef.isSelected = false
        
     //   sender.isSelected = !sender.isSelected
        sender.isSelected = true
        if sender.isSelected{
            items1 = items1.mapValues { $0.sorted { ($0["email"] as? String ?? "").localizedCaseInsensitiveCompare($1["email"] as? String ?? "") == .orderedAscending } }
            tbl.reloadData()
            searchField.placeholder = "Search Email here"
        }

    }
    
    @IBAction func IDFilt(_ sender: UIButton) {
        
        arrowBtn.isSelected = false
        nameBtnRef.isSelected = false
        emailBtnRef.isSelected = false
        
      //  sender.isSelected = !sender.isSelected
        sender.isSelected = true
        if sender.isSelected{
            items1 = items1.mapValues { $0.sorted { ($0["Emp_id"] as? Int ?? 0) < ($1["Emp_id"] as? Int ?? 0)} }
            tbl.reloadData()
            searchField.placeholder = "Search ID here"
        }
    }
    
    @IBAction func searchHere(_ sender: UITextField) {

        if nameBtnRef.isSelected{
            searchResults = searchEmployees(input : sender.text!, spec1: "name")
        }else if emailBtnRef.isSelected{
            searchResults = searchEmployees(input : sender.text!, spec1: "email")
        }else if IDBtnRef.isSelected{
            if sender.text == ""{
                items1 = items
                tbl.reloadData()
            }else{
                let intVal = Int(sender.text!)
                searchResults = searchEmployeesId(input: intVal ?? 0, spec1: "Emp_id")
            }
        }
        
        items1.removeValue(forKey: "Employee_details")
        let newKey = "Employee_details"
        let newValue: [[String: Any]] = searchResults
        items1[newKey] = newValue
        tbl.reloadData()
    }
    
    func searchEmployees(input: String,spec1: String) -> [[String: Any]] {
        if let employeeDetails = items["Employee_details"] {
            let filteredArray = employeeDetails.filter {
                if let employeeName = $0[spec1] as? String {
                    return employeeName.lowercased().hasPrefix(input.lowercased())
                    items1.removeValue(forKey: "Employee_details")
                    
                }
                return false
            }
            return filteredArray
        }
        return []
    }
    
    func searchEmployeesId(input: Int, spec1: String) -> [[String: Any]] {
        if let employeeDetails = items["Employee_details"] {
            let filteredArray = employeeDetails.filter { employee in
                if let value = employee[spec1] as? Int {
                    return value == input
                }
                return false
            }
            return filteredArray
        }
        return []
    }
    func didEditEmployeeDetails(name: String, email: String, empId: Int) {
        name1 = name
        email1 = email
        empID1 = empId
        if change == "Edit"{
            if var employeeDetails = items["Employee_details"] {
                //  let indexToUpdate = indexPath
                let updatedDetails: [String: Any] = [
                    "name": name1,
                    "email": email1,
                    "Emp_id": empID1
                ]
                employeeDetails[0] = updatedDetails
                items1["Employee_details"] = employeeDetails
            }
            
        }else{
            
            let newEmployee: [String: Any] = [
                "name": name1,
                "email": email1,
                "Emp_id": empID1
            ]

            items1["Employee_details"]?.append(newEmployee)
        }
        
    }
}
extension HomePage : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items1["Employee_details"]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl.dequeueReusableCell(withIdentifier: "list", for: indexPath)as!ListTableViewCell
        let employeeDetails = items1["Employee_details"]?[indexPath.row]
        cell.name.text = employeeDetails?["name"] as? String
        cell.email.text = employeeDetails?["email"] as? String
        let idNo = employeeDetails?["Emp_id"] as? Int
        if let val = idNo{
            cell.id.text = "\(val)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if var employeeDetails = items1["Employee_details"] {
                employeeDetails.remove(at: indexPath.row)
                items1["Employee_details"] = employeeDetails
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            
            self.editRow(at: indexPath)
            
            completionHandler(true)
        }
        editAction.backgroundColor = .blue
        
        let configuration = UISwipeActionsConfiguration(actions: [editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

    func editRow(at indexPath: IndexPath) {
       
        let strybrd = UIStoryboard(name: "Main", bundle: nil)
        let vc = strybrd.instantiateViewController(withIdentifier: "add")as!AddDetailsViewController
        change = "Edit"
        vc.changeMadeDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
       
    }

}


