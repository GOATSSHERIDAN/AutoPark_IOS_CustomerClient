//
//  PasswordRecoverViewController.swift
//  AutoPark_GOATS_UserApplication
//
//  Created by cuilin on 2020-10-05.
//

import UIKit
import FirebaseFirestore
class PasswordRecoverViewController: UIViewController {
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBOutlet var btnSendCode : UIButton!
    @IBOutlet var btnSubmit : UIButton!

    @IBOutlet var userIdField : UITextField!
    @IBOutlet var phoneNumberField : UITextField!
    @IBOutlet var securyCodeField : UITextField!
    

    
    @IBOutlet weak var errorLabel: UILabel!
    @IBAction func sendSecuryCode(sender : UIButton){
        
        let phoneNumber = phoneNumberField.text ??  "00000"
        let db = Firestore.firestore()
        db.collection("Users").document(userIdField.text ?? "not user").getDocument { (document, error) in
          
            if error == nil{
                //check if user exist
                if document != nil && document!.exists{
                    let realDoc = document!.data()
                    let realPhoneNumber = realDoc!["phone"] as! String
                    if realPhoneNumber == phoneNumber{
                        
                        let phoneNumber = self.phoneNumberField.text
                        VerifyAPI.sendVerificationCode("1", phoneNumber!)
                        let alertController = UIAlertController(title: "Sent", message: "Please check your phone!", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
                        alertController.addAction(cancelAction)
                        self.present(alertController,animated: true)
                        self.mainDelegate.resetPasswordFor = self.userIdField.text ?? ""
                        self.mainDelegate.resetPasswordDoc = realDoc
                        
                        
                    }else{
                        let alertController = UIAlertController(title: "Error", message: "User ID and phone number not match, Please re-try!", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
                        alertController.addAction(cancelAction)
                        self.present(alertController,animated: true)
                    }
                }else{
                    let alertController = UIAlertController(title: "Error", message: "User ID not exist, Please re-try!", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(cancelAction)
                    self.present(alertController,animated: true)
                    
                }
            }else{
                print(error ?? "no error")
            }
        }
    }
    
    //var countryCode: String?
    var phoneNumber: String?
    var resultMessage: String?
    
    @IBAction func validateCode() {
        if let code = securyCodeField.text {
            VerifyAPI.validateVerificationCode("1", phoneNumberField.text!, code) { checked in
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
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
