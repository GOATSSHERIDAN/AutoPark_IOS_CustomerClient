//
//  PasswordRecoverViewController.swift
//  AutoPark_GOATS_UserApplication
//
//  Created by cuilin on 2020-10-05.
//

import UIKit

class PasswordRecoverViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBOutlet var btnSendCode : UIButton!
    @IBOutlet var btnSubmit : UIButton!

    @IBOutlet var countryCodeField : UITextField!
    @IBOutlet var phoneNumberField : UITextField!
    @IBOutlet var securyCodeField : UITextField!
    
    
    @IBAction func sendSecuryCode(sender : UIButton){
        let countryCode = countryCodeField.text
        let phoneNumber = phoneNumberField.text
        VerifyAPI.sendVerificationCode(countryCode!, phoneNumber!)
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
