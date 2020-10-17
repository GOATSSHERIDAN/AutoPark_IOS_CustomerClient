//
//  VerifyEmailViewController.swift
//  AutoPark_GOATS_UserApplication
//
//  Created by 崔林 on 2020-10-16.
//

import UIKit
import FirebaseFirestore
class VerifyEmailViewController: ViewController {
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var tfCode: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doVerification(_ sender: Any) {
        
        if tfCode.text ?? "0" == mainDelegate.randomCode ?? "1"{
            let db = Firestore.firestore()
            
            
            let newUser = mainDelegate.newUser!
            
            db.collection("Users").document(newUser.userId).setData(["email":newUser.email,"firstName":newUser.firstName,"lastName":newUser.lastName,"password":newUser.password,"phone":newUser.phoneNumber])
            self.performSegue(withIdentifier: "goToMainPage", sender: nil)
            
        }else{
            let alertController = UIAlertController(title: "Error", message: "Code not match, please try again!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(cancelAction)
            self.present(alertController,animated: true)
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
