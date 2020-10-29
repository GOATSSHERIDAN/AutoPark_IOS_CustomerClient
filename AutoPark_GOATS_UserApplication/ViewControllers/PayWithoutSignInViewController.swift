//
//  PayWithoutSignInViewController.swift
//  AutoPark_GOATS_UserApplication
//
//  Created by Lin Cui on 2020-10-29.
//

import UIKit
import PassKit

class PayWithoutSignInViewController: UIViewController,UIApplicationDelegate, PKPaymentAuthorizationViewControllerDelegate{
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
    
    
    
    @IBOutlet weak var btn_pay: UIButton!
    
    let paymentAmount : Double = 1001
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btn_pay.addTarget(self, action: #selector(tapForPay), for: .touchUpInside)
        // Do any additional setup after loading the view.
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
