//
//  ViewCarsViewController.swift
//  AutoPark_GOATS_UserApplication
//
//  Created by Lin Cui on 2020-10-31.
//

import UIKit
import FirebaseFirestore

class ViewCarsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var carsTable: UITableView!
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    var cars : [String] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier:
                                                        "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        tableCell.textLabel?.text = self.cars[indexPath.row]

        tableCell.textLabel?.font = UIFont.systemFont(ofSize: 12.5,weight: .bold)
        tableCell.accessoryType = .disclosureIndicator
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete"){
            (action, index) in
            //print ("Delete button tapped")
            let rowNum = indexPath.row
            var deleteId = self.cars[rowNum]
            print("\(deleteId) should be deleted now!")
            let db = Firestore.firestore()
            db.collection("LicencePlateNumber").document(deleteId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    self.getCars()
                }
            }
            
        }
        deleteAction.backgroundColor = .red

        return [deleteAction]
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCars()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getCars(){
        cars = []
        let userId = mainDelegate.signedDocName!
        
        let db = Firestore.firestore()
        
        let myData = db.collection("LicencePlateNumber").whereField("userId", isEqualTo: userId).getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID)")
                    self.cars.append(document.documentID)
                }
                self.carsTable.reloadData()
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
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
