//
//  ViewController.swift
//  AutoPark_GOATS_UserApplication
//
//  Created by cuilin on 2020-10-05.
//

import UIKit
import FirebaseDatabase
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let ref = Database.database().reference()
        ref.child("Users/1/LicensePlate").setValue("CDJJCNM")
    }

    @IBAction func unwindToHomeViewController(sender : UIStoryboardSegue){
        
    }
}

