//
//  SendEmailReciptViewController.swift
//  AutoPark_GOATS_UserApplication
//
//  Created by Lin Cui on 2020-11-22.
//

import UIKit

class SendEmailReciptViewController: UIViewController {

    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var errorForEmail: UILabel!
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        emailTf.textColor = .black
        emailTf.backgroundColor = .white
        super.viewDidLoad()
        emailTf.addTarget(self, action: #selector(checkAndDisPlayErrorForEmail(emailTf:)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    @objc func checkAndDisPlayErrorForEmail(emailTf:UITextField){
        
        if ( !isValidEmail(email:emailTf.text!)){
            errorForEmail.text = "Email address is invalid!"
            btnSend.isEnabled  = false
        }
        
        else{
            errorForEmail.text = " "
            btnSend.isEnabled  = true
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @IBAction func sendRecipt(_ sender: Any) {
        
        if emailTf.text!.isEmpty{
            let alertController = UIAlertController(title: "Error", message: "Please fill all fields", preferredStyle: .alert)
            let cancelAction1 = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction1)
            self.present(alertController,animated: true)
        }else{
            
            sendRecipt(destEmail: emailTf.text ?? "error", amount: mainDelegate.parkingAmount ?? "error")
            
            let alertController = UIAlertController(title: "Reciept Sent", message: "Thank you for using AutoPark", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .default, handler: {
                action in
                self.dismissToViewControllers()
            })
            alertController.addAction(cancelAction)
            self.present(alertController,animated: true)
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
                builder.htmlBody="<h1>Parking Recipt</h1><p>Amount: $\(amount)</p><h2>Thank you for using AutoPark</h2>"
        
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
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func dismissToViewControllers() {

        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
}
