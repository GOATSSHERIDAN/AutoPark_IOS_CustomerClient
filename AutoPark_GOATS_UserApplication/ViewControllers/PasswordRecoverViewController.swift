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
    

    
    @IBOutlet weak var errorLabel: UILabel!
    @IBAction func sendSecuryCode(sender : UIButton){
        let countryCode = countryCodeField.text
        let phoneNumber = phoneNumberField.text
        VerifyAPI.sendVerificationCode(countryCode!, phoneNumber!)
        let alertController = UIAlertController(title: "Sent", message: "Please check your phone!", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        self.present(alertController,animated: true)
    }
    
    var countryCode: String?
    var phoneNumber: String?
    var resultMessage: String?
    
    @IBAction func validateCode() {
        if let code = securyCodeField.text {
            VerifyAPI.validateVerificationCode(countryCodeField.text!, phoneNumberField.text!, code) { checked in
                if (checked.success) {
                    self.resultMessage = checked.message
                    self.performSegue(withIdentifier: "showResetPasswordPage", sender: nil)
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Invalid code, Please re-try!", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(cancelAction)
                    self.present(alertController,animated: true)
                }
            }
        }
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
