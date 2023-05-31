//
//  AddDetailsViewController.swift
//  HigherOrder
//
//  Created by AKHIL N P on 25/05/23.
//

import UIKit
protocol EditAndAdd {
    func didEditEmployeeDetails(name: String, email: String, empId: Int)
}

class AddDetailsViewController: UIViewController {

    @IBOutlet weak var empIDlbl: UILabel!
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var emailCheckLbl: UILabel!
    
    @IBOutlet weak var nameChecklbl: UILabel!
    
    @IBOutlet weak var submitBtnRef: UIButton!
    
    var changeMadeDelegate: EditAndAdd?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func nameCheck(_ sender: Any) {
        if nameText.text != ""{
            nameChecklbl.text = ""
        }
    }
    
    @IBAction func emailfield(_ sender: Any) {
        if nameText.text == ""{
            nameChecklbl.text = "Please Enter Your Name"
            nameChecklbl.textColor = .red
        }
       
        if let email = emailText.text
        {
            if let errorMessage = invalidEmail(email)
            {
                emailCheckLbl.text = errorMessage
                emailCheckLbl.isHidden = false
                
                emailCheckLbl.textColor = .red
            }
            else
            {
                emailCheckLbl.text = ""
              //  emailText.borderColor = .systemGray
            }
        }
        
      //  checkForValidForm()
    }

    func invalidEmail(_ value: String) -> String?
    {
        let reqularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        if !predicate.evaluate(with: value)
        {
            return "Invalid Email Address"
        }
        
        return nil
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        if emailCheckLbl.text == "" && nameChecklbl.text == "" && emailText.text != "" && nameText.text != ""{
            changeMadeDelegate?.didEditEmployeeDetails(name: nameText.text!, email: emailText.text!, empId: 77)
            print("Sussess")
            self.navigationController?.popViewController(animated: true)
        }else{
            if emailText.text == "" && nameText.text == ""{
                emailCheckLbl.text = "Enter Your Email Address"
                emailCheckLbl.textColor = .red
                nameChecklbl.text = "Enter your name"
                nameChecklbl.textColor = .red
            }else if nameText.text == ""{
                nameChecklbl.text = "Enter your name"
                nameChecklbl.textColor = .red
            }
        }
    }
}


