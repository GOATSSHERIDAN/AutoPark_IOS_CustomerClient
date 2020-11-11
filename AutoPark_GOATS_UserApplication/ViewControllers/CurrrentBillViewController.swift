//
//  CurrrentBillViewController.swift
//  AutoPark_GOATS_UserApplication
//
//  Created by Lin Cui on 2020-10-31.
//

import UIKit
import FirebaseFirestore
import PassKit

class CurrrentBillViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,UIApplicationDelegate, PKPaymentAuthorizationViewControllerDelegate {
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var lbShowName: UILabel!
    @IBOutlet weak var lbFees: UILabel!
    
    @IBOutlet weak var billTable: UITableView!
    
    var feeOwned : Int = 0
    var processedDocId : [String] = []
    var cars : [String] = []
    var tableInfo :[String] = []
    override func viewDidLoad() {
        
        super.viewDidLoad()
        lbShowName.text = mainDelegate.signedUser?["firstName"] as! String
        getHistory()
        self.btn_pay.addTarget(self, action: #selector(tapForPay), for: .touchUpInside)
    }
    
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
                    db.collection("ParkingHistory").whereField("isPaid", isEqualTo: false).whereField("licensePlate", in: self.cars).getDocuments() { (querySnapshot2, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot2!.documents {
                                print("\(document.documentID)")
                                self.processedDocId.append(document.documentID)
                                self.feeOwned += document["fee"] as! Int
                                //self.tableInfo.append("\(document["startDateTime"])  \(document["endDateTime"])  $\(document["fee"])")
                                self.tableInfo.append("\(document.documentID)---$\(document["fee"] as! Int)")
                            }
                            self.lbFees.text = "Amount: $\(self.feeOwned)"
                            print(self.tableInfo)
                            self.billTable.reloadData()
                        }
                        
                    }
                }
            }
    }
    
    
    
    
    
    //payment part
    @IBOutlet weak var btn_pay: UIButton!
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        print("yes you paid")
        feeOwned = 0
        for doc in processedDocId {
            let db = Firestore.firestore()
            let myData = db.collection("ParkingHistory").document(doc)
            myData.updateData(["isPaid":true])
            { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document:\(doc) successfully updated")
                }
            }
        }
        tableInfo = []
        billTable.reloadData()
    }
    
    @objc func tapForPay(){
        let paymentRequest : PKPaymentRequest = {
            let request  = PKPaymentRequest()
            request.merchantIdentifier = "merchant.ca.sheridancollege.AutoPark-GOATS-UserApplication"
            request.supportedNetworks = [.quicPay, .masterCard, .visa]
            request.supportedCountries = ["CA"]
            request.merchantCapabilities = .capability3DS
            request.countryCode = "CA"
            request.currencyCode = "CAD"
            request.paymentSummaryItems = [PKPaymentSummaryItem(label: "GIVE ME MONEY", amount: NSDecimalNumber(value: feeOwned))]
            return request
        }()
        let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        if controller != nil {
            controller!.delegate = self
            present(controller!, animated: true){
                print("completed")
                
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
