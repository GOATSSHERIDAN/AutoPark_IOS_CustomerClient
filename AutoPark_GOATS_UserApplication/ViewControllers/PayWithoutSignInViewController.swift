//
//  PayWithoutSignInViewController.swift
//  AutoPark_GOATS_UserApplication
//
//  Created by Lin Cui on 2020-10-29.
//

import UIKit
import PassKit
import FirebaseFirestore


class PayWithoutSignInViewController: UIViewController,UIApplicationDelegate, PKPaymentAuthorizationViewControllerDelegate{
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
                    let alertController = UIAlertController(title: "Payment Successful", message: "Do you want a email copy of your recipt?", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
                    let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { action in
                        print("we will send email to user")
                        self.performSegue(withIdentifier: "goToSendRecipt", sender: self)
                        
                    })
                    alertController.addAction(cancelAction)
                    alertController.addAction(yesAction)
                    self.present(alertController,animated: true)
                }
            }
        }
     
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var btn_pay: UIButton!
    
    @IBOutlet weak var plateNumber: UITextField!
    
    @IBOutlet weak var lbAmount: UILabel!
    
    var paymentAmount : Double = 0
    
    var feeOwned = 0
    
    var processedDocId : [String] = []
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        lbAmount.text = "$0.0"
        self.btn_pay.addTarget(self, action: #selector(tapForPay), for: .touchUpInside)
        btn_pay.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func searchAmount(_ sender: Any) {
        if plateNumber.text!.isEmpty {
            let alertController = UIAlertController(title: "Error", message: "Please fill it!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController,animated: true)
        }else{
            
            let db = Firestore.firestore()
            
            let _: Void = db.collection("ParkingHistory").whereField("isPaid", isEqualTo: false).whereField("licensePlate", isEqualTo: plateNumber.text ?? "000")
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID)")
                            self.processedDocId.append(document.documentID)
                            self.feeOwned += document["fee"] as! Int
                        }
                        print(self.feeOwned)
                        self.lbAmount.text = "$ \(self.feeOwned)"
                        self.paymentAmount = Double(self.feeOwned)
                        if self.paymentAmount != 0{
                            self.btn_pay.isEnabled = true
                            self.mainDelegate.parkingAmount = "\(self.paymentAmount)"
                        }
                    }
                }
            
            
            
            
            
        }
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
            request.paymentSummaryItems = [PKPaymentSummaryItem(label: "GIVE ME MONEY", amount: NSDecimalNumber(value: paymentAmount))]
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

//extension ViewController : PKPaymentAuthorizationViewControllerDelegate {
//    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
//        controller.dismiss(animated: true, completion: nil)
//    }
//    
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
//        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
//    }
//}
