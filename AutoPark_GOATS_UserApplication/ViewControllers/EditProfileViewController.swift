//
//  EditProfileViewController.swift
//  AutoPark_GOATS_UserApplication
//
//  Created by Lin Cui on 2020-10-31.
//

import UIKit
import FirebaseFirestore

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfphoneNumber: UITextField!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var errorForEmail: UILabel!
    @IBOutlet weak var btnSubmit: UIBarButtonItem!
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print(mainDelegate.signedUser!)
        tfEmail.text = mainDelegate.signedUser?["email"] as! String
        tfphoneNumber.text = mainDelegate.signedUser?["phone"] as! String
        tfFirstName.text = mainDelegate.signedUser?["firstName"] as! String
        tfLastName.text = mainDelegate.signedUser?["lastName"] as! String
        tfEmail.addTarget(self, action: #selector(checkAndDisPlayErrorForEmail(tfEmail:)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    
    @objc func checkAndDisPlayErrorForEmail(tfEmail:UITextField){
        
        if ( !isValidEmail(email:tfEmail.text!)){
            errorForEmail.text = "Email address is invalid!"
            btnSubmit.isEnabled  = false
        }
        
        else{
            errorForEmail.text = " "
            btnSubmit.isEnabled  = true
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: Any) {
        
        let userId = mainDelegate.signedDocName!
        
        if tfEmail.text!.isEmpty || tfphoneNumber.text!.isEmpty || tfFirstName.text!.isEmpty || tfLastName.text!.isEmpty
        {
            let alertController = UIAlertController(title: "Error", message: "Please fill all!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(cancelAction)
            self.present(alertController,animated: true)
        }else{
            
            let db = Firestore.firestore()
            let myData = db.collection("Users").document(userId)
            myData.updateData(["firstName":tfFirstName.text!,"lastName":tfLastName.text!,"email":tfEmail.text!,"phone":tfphoneNumber.text!])
                {
                err in
                if let err = err {
                    print("Error updating document: \(err)")
                }else{
                    
                }
                
            }
//            myData.updateData(["lastName":tfLastName.text!])
//            myData.updateData(["email":tfEmail.text!])
//            myData.updateData(["phone":tfphoneNumber.text!])
            var information = "First Name:\(tfFirstName.text! as! String)  ,Last Name:\(tfLastName.text as! String),  Phone Number: \(tfphoneNumber.text! as! String) "
            
            if mainDelegate.signedUser?["email"] as! String != tfEmail.text!{
                sendNotify(destEmail: mainDelegate.signedUser?["email"] as! String, information: information)
            }
            
            sendNotify(destEmail: tfEmail.text!, information: information)
            let alertController = UIAlertController(title: "Successful", message: "Information updated, an copy of email also send to original email address", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(cancelAction)
            self.present(alertController,animated: true)
            
            // do a unwind
        }
    }
    
    func sendNotify(destEmail:String,information:String){
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
                builder.htmlBody="<h1>You Just Edit your informaion</h1><p>Information: \(information)</p><h2>If you didn't authorize this, pleast contact us NOW!</h2>"
        
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
}
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


