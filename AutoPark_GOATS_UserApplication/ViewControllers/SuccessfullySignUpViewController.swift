//
//  SuccessfullySignUpViewController.swift
//  AutoPark_GOATS_UserApplication
//
//  Created by cuilin on 2020-10-05.
//

import UIKit

class SuccessfullySignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToSignIn(_ sender: Any) {
        performSegue(withIdentifier: "goToSignInPage", sender: nil)
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
