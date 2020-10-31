//
//  SignInViewController.swift
//  AutoPark_GOATS_UserApplication
//
//  Created by cuilin on 2020-10-05.
//

import UIKit
import FirebaseFirestore


class SignInViewController: UIViewController {

    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let db = Firestore.firestore()
        //db.collection("Users").document(userIdTextField.text!)
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func doSignIn(_ sender: UIButton) {
        let db = Firestore.firestore()
        let password = passwordTextfield.text!
        
        let _: Void = db.collection("Users").document(userIdTextField.text!).getDocument { (document, error) in
            
            if error == nil{
                //check if user exist
                if document != nil && document!.exists{
                    let realDoc = document!.data()
                    let realPassword = realDoc!["password"] as! String
                    if realPassword == password{
                        self.mainDelegate.signedUser = realDoc
                        self.mainDelegate.signedDocName = self.userIdTextField.text!
                        self.performSegue(withIdentifier: "goToMenu", sender: nil)
                    }else{
                        let alertController = UIAlertController(title: "Error", message: "Invalid Password, Please re-try!", preferredStyle: .alert)
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
                print(error ?? "not found error")
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
