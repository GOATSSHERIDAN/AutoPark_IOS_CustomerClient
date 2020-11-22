//
//  SendEmailReciptViewController.swift
//  AutoPark_GOATS_UserApplication
//
//  Created by Lin Cui on 2020-11-22.
//

import UIKit

class SendEmailReciptViewController: UIViewController {

    @IBOutlet weak var emailTf: UITextField!
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendRecipt(_ sender: Any) {
        
        if emailTf.text!.isEmpty{
            let alertController = UIAlertController(title: "Error", message: "Please fill all", preferredStyle: .alert)
            let cancelAction1 = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction1)
            self.present(alertController,animated: true)
        }else{
            sendRecipt(destEmail: emailTf.text ?? "error", amount: mainDelegate.parkingAmount ?? "error")
            
            let alertController = UIAlertController(title: "Recipt Sent", message: "Thank you for using our product", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .default, handler: {
                action in
                self.dismiss(animated: true, completion: nil)
                
            })
            alertController.addAction(cancelAction)
            self.present(alertController,animated: true)
            //self.dismiss(animated: true, completion: nil)
        }
    }
    
    func sendRecipt(destEmail:String,amount:String){
        let smtpSession = MCOSMTPSession()
        
                smtpSession.hostname = "smtp.gmail.com"
                smtpSession.username = "goatsteam.2020@gmail.com"
                smtpSession.password = "sheridancollege2020"
                smtpSession.port = 465
                smtpSession.authType = MCOAuthType.saslPlain
                smtpSession.connectionType = MCOConnectionType.TLS
        
                smtpSession.connectionLogger = {(connectionID, type, data) in
                    if data != nil {
                        if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                            NSLog("Connectionlogger: \(string)")
                        }
                    }
                }
                let builder = MCOMessageBuilder()
        
        builder.header.to = [MCOAddress(displayName: "New User", mailbox: destEmail) as Any]
                builder.header.from = MCOAddress(displayName: "GOATSTEAM", mailbox: "goatsteam.2020@gmail.com")
                builder.header.subject = "Parking Recipt"
                builder.htmlBody="<h1>Parking Recipt</h1><p>Amount: $\(amount)</p><h2>Thank you for using our application</h2>"
        
                let rfc822Data = builder.data()
                let sendOperation = smtpSession.sendOperation(with: rfc822Data)
                sendOperation?.start { (error) -> Void in
                    if (error != nil) {
                        print("Error sending email: \(String(describing: error))")
                    } else {
                        print("Successfully sent email!")
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
