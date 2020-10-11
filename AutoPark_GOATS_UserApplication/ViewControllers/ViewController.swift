//
//  ViewController.swift
//  AutoPark_GOATS_UserApplication
//
//  Created by cuilin on 2020-10-05.
//

import UIKit
<<<<<<< HEAD
import FirebaseFirestore
=======
>>>>>>> parent of 7caf31e... week4 update(SMS verification)

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
<<<<<<< HEAD
       // let ref = Database.database().reference()
        
        //ref.("Users/dave1/firstName").setValue("CDJJCNM")
        let db = Firestore.firestore()
        db.collection("Users").document("dave1").setData(["lastName":"hahaha"])
        
=======
>>>>>>> parent of 7caf31e... week4 update(SMS verification)
    }

    @IBAction func unwindToHomeViewController(sender : UIStoryboardSegue){
        
    }
}

