//
//  ViewController.swift
//  AutoPark_GOATS_UserApplication
//
//  Created by cuilin on 2020-10-05.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       // let ref = Database.database().reference()
        
        //ref.("Users/dave1/firstName").setValue("CDJJCNM")
        let db = Firestore.firestore()
        db.collection("Users").document("dave1").setData(["lastName":"hahaha"])
        
    }

    @IBAction func unwindToHomeViewController(sender : UIStoryboardSegue){
        
    }
}

