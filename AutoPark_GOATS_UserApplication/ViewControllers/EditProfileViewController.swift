//
//  EditProfileViewController.swift
//  AutoPark_GOATS_UserApplication
//
//  Created by Lin Cui on 2020-10-31.
//

import UIKit
import FirebaseFirestore

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfphoneNumber: UITextField!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: Any) {
        
        let userId = mainDelegate.signedDocName!
        
        if tfEmail.text!.isEmpty || tfphoneNumber.text!.isEmpty || tfFirstName.text!.isEmpty || tfLastName.text!.isEmpty
        {
            let alertController = UIAlertController(title: "Error", message: "Please fill all!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(cancelAction)
            self.present(alertController,animated: true)
        }else{
            
            let db = Firestore.firestore()
            let myData = db.collection("Users").document(userId)
            myData.updateData(["firstName":tfFirstName.text!,"lastName":tfLastName.text!,"email":tfEmail.text!,"phone":tfphoneNumber.text!])
                {
                err in
                if let err = err {
                    print("Error updating document: \(err)")
                }else{
                    
                }
                
            }
//            myData.updateData(["lastName":tfLastName.text!])
//            myData.updateData(["email":tfEmail.text!])
//            myData.updateData(["phone":tfphoneNumber.text!])
            
            let alertController = UIAlertController(title: "Successful", message: "Information updated", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(cancelAction)
            self.present(alertController,animated: true)
            
            // do a unwind
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


