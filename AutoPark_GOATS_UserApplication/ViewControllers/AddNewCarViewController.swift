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
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doAdd(_ sender: Any) {
        let userId = mainDelegate.signedDocName
        let db = Firestore.firestore()
        db.collection("LicencePlateNumber").document(tfPlatenumber.text!).setData(["userId":userId,"make":tfMake.text!,"color":tfColor.text!])
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

}
