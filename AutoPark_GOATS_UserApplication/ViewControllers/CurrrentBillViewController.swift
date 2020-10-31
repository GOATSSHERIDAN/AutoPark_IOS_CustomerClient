//
//  CurrrentBillViewController.swift
//  AutoPark_GOATS_UserApplication
//
//  Created by Lin Cui on 2020-10-31.
//

import UIKit

class CurrrentBillViewController: UIViewController {
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var lbShowName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbShowName.text = mainDelegate.signedUser!["firstName"] as? String
        // Do any additional setup after loading the view.
    }
    

    // finish these two and we are don for this
    
    func findPlatesByUser(userId : String) -> [String]{
        
        return [""]
        
    }
    
    
    func findHistoryByPlate(licencePlates : [String]) -> [[String:Any]]{
        
        return [["":""]]
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
