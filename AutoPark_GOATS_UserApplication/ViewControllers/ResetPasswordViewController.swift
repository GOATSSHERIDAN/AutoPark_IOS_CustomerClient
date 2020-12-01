//
//  ResetPasswordViewController.swift
//  AutoPark_GOATS_UserApplication
//
//  Created by cuilin on 2020-10-05.
//

import UIKit
import FirebaseFirestore
class ResetPasswordViewController: UIViewController {

    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var reTypePassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func doUpdate(_ sender: Any) {
        
        if tfPassword.text!.isEmpty || reTypePassword.text!.isEmpty
        {
            let alertController = UIAlertController(title: "Error", message: "Please fill all!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(cancelAction)
            self.present(alertController,animated: true)
        }else{
            if tfPassword.text! != reTypePassword.text!{
                let alertController = UIAlertController(title: "Error", message: "Please check your password!", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(cancelAction)
                self.present(alertController,animated: true)
            }else{
                let userId = mainDelegate.resetPasswordFor ?? ""
                var userInfo = mainDelegate.resetPasswordDoc ?? [" ":" "]
                userInfo["password"] = tfPassword.text ?? ""
                let db = Firestore.firestore()
                db.collection("Users").document(userId).setData(userInfo)
                let alertController = UIAlertController(title: "Successful", message: "Password updated", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(cancelAction)
                self.present(alertController,animated: true)
                
                // do a unwind 
                }
            }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
