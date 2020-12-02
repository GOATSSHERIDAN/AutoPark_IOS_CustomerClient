//
//  AddNewCarViewController.swift
//  AutoPark_GOATS_UserApplication
//
//  Created by Lin Cui on 2020-10-31.
//

import UIKit
import FirebaseFirestore

class AddNewCarViewController: UIViewController {
    
    @IBOutlet weak var tfPlatenumber: UITextField!
    @IBOutlet weak var tfMake: UITextField!
    @IBOutlet weak var tfColor: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var errorForNumber: UILabel!
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfPlatenumber.addTarget(self, action: #selector(checkAndDisPlayErrorForPlateNumber(tfPlatenumber:)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doAdd(_ sender: Any) {
        
        if tfPlatenumber.text!.isEmpty || tfMake.text!.isEmpty || tfColor.text!.isEmpty{
            let alertController = UIAlertController(title: "Error", message: "Please fill all!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(cancelAction)
            self.present(alertController,animated: true)
        }else{
            
            let userId = mainDelegate.signedDocName
            let db = Firestore.firestore()
            db.collection("LicencePlateNumber").document(tfPlatenumber.text!).setData(["userId":userId,"make":tfMake.text!,"color":tfColor.text!])
            
            let alertController = UIAlertController(title: "Message", message: "Car added!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(cancelAction)
            self.present(alertController,animated: true)
        }
        
    }
    
    @objc func checkAndDisPlayErrorForPlateNumber(tfPlatenumber:UITextField){
        
        if (tfPlatenumber.text?.count ?? 0  > 7 ){
            errorForNumber.text = "Maxima 7 chars for Licence Plate Number"
            btnAdd.isEnabled  = false
        }
        
        else{
            errorForNumber.text = " "
            btnAdd.isEnabled  = true
        }
    }
    
    
    
    
    
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
