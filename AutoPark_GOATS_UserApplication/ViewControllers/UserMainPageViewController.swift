//
//  UserMainPageViewController.swift
//  AutoPark_GOATS_UserApplication
//
//  Created by cuilin on 2020-10-05.
//

import UIKit

class UserMainPageViewController: UIViewController {

    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var lbShowName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(mainDelegate.signedUser)
        lbShowName.text = mainDelegate.signedUser!["firstName"] as? String
        // Do any additional setup after loading the view.
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
