//
//  ParkingHistoryViewController.swift
//  AutoPark_GOATS_UserApplication
//
//  Created by Lin Cui on 2020-10-31.
//

import UIKit
import FirebaseFirestore

class ParkingHistoryViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var historyTable: UITableView!
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    var cars : [String] = []
    var tableInfo :[String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier:
            "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        tableCell.textLabel?.text = tableInfo[indexPath.row]
        
        tableCell.textLabel?.font = UIFont.systemFont(ofSize: 12.5,weight: .bold)
        tableCell.accessoryType = .disclosureIndicator
        return tableCell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHistory()
        // Do any additional setup after loading the view.
    }
    
    func getHistory(){
        let db = Firestore.firestore()
        var result = db.collection("LicencePlateNumber").whereField("userId", isEqualTo: mainDelegate.signedDocName!)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print(document.documentID)
                        self.cars.append(document.documentID)
                    }
                    print(self.cars)
                    db.collection("ParkingHistory").whereField("isPaid", isEqualTo: true).whereField("licensePlate", in: self.cars).getDocuments() { (querySnapshot2, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot2!.documents {
                                print("\(document.documentID)")
                                self.tableInfo.append("\(document.documentID)---$\(document["fee"] as! Int)")
                            }
                            
                            self.historyTable.reloadData()
                        }
                        
                    }
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
