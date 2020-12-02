//
//  SignUpViewController.swift
//  AutoPark_GOATS_UserApplication
//
//  Created by cuilin on 2020-10-05.
//

import UIKit
import FirebaseFirestore
class SignUpViewController: UIViewController {
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    var isEmailVerified : Bool = false
    
    @IBAction func unwindToSignUpViewController(sender : UIStoryboardSegue){
        
    }
    @IBOutlet weak var tfUserId: UITextField!
    
    @IBOutlet weak var btSubmit: UIBarButtonItem!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var tfReTypePassword: UITextField!
    @IBOutlet weak var tfFName: UITextField!
    
    @IBOutlet weak var tfLName: UITextField!
    
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfPhoneNumber: UITextField!
    
    
    @IBOutlet weak var btnSubmit: UIBarButtonItem!
    
    @IBAction func doSubmit(sender : Any){
        if tfUserId.text!.isEmpty || tfPassword.text!.isEmpty || tfReTypePassword.text!.isEmpty || tfFName.text!.isEmpty || tfLName.text!.isEmpty || tfEmail.text!.isEmpty || tfPhoneNumber.text!.isEmpty {
            let alertController = UIAlertController(title: "Error", message: "Please fill all!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(cancelAction)
            self.present(alertController,animated: true)
        }else{
            if tfReTypePassword.text! != tfPassword.text!{
                let alertController = UIAlertController(title: "Error", message: "Please check your password!", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(cancelAction)
                self.present(alertController,animated: true)
            }else{
                var userExist = 0
                //remove later!!!!!!!! add check userif exist
                let db = Firestore.firestore()
                db.collection("Users").document(tfUserId.text!).getDocument { (document, error) in
                    if error == nil{
                        if document != nil && document!.exists{
                            userExist  = 1
                        }else{
                            print("user Not exist")
                        }
                    }
                    else{
                        print(error ?? "not found error")
                        
                    }
                }
                if userExist == 0{
                   
                    db.collection("Users").document(tfUserId.text!).getDocument{(document,error) in
                        
                        if error == nil{
                            if document != nil && document!.exists{
                                //user id already exist
                                let alertController = UIAlertController(title: "Error", message: "User ID already been used!", preferredStyle: .alert)
                                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alertController.addAction(cancelAction)
                                self.present(alertController,animated: true)
                            }else{
                                //can go ahead
                                self.mainDelegate.newUser = User(userId: self.tfUserId.text!,password: self.tfPassword.text!,firstName: self.tfFName.text!,lastName: self.tfLName.text!,email: self.tfEmail.text!,phoneNumber: self.tfPhoneNumber.text!)
                                self.mainDelegate.randomCode = self.randomString(length: 4)
                                self.sendVerificationCode(destEmail: self.tfEmail.text!, verificationCode: self.mainDelegate.randomCode ?? "default value code, this is error")
                                print(self.mainDelegate.randomCode ?? "not found code")
                                self.performSegue(withIdentifier: "goEmailVerify", sender: nil)
                            }
                        }else{
                            print(error ?? "")
                        }
                    }
                    
                }else{
                    print("User name exist, please change one!")
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isEmailVerified = false
        tfUserId.addTarget(self, action: #selector(checkAndDisPlayErrorForUserId(tfUserId:)), for: .editingChanged)
        tfEmail.addTarget(self, action: #selector(checkAndDisPlayErrorForEmail(tfEmail:)), for: .editingChanged)
        //sendVerificationCode(destEmail:"cuilin940127@gmail.com")
        // Do any additional setup after loading the view.
       
    }
    @IBOutlet weak var errorForUserId: UILabel!
    @IBOutlet weak var errorForEmail: UILabel!
    
    @objc func checkAndDisPlayErrorForUserId(tfUserId:UITextField){
        let characterset = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        
        if (tfUserId.text?.count ?? 0  > 16 ){
            errorForUserId.text = "Maxima 16 chars for UserID"
            btnSubmit.isEnabled  = false
        }
        else if tfUserId.text?.rangeOfCharacter(from: characterset.inverted) != nil{
            print("string contains special characters")
            
            errorForUserId.text = "no special characters"
            btnSubmit.isEnabled  = false
        }
        else{
            errorForUserId.text = " "
            btnSubmit.isEnabled  = true
        }
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
    
    
    
    
    func sendVerificationCode(destEmail:String,verificationCode:String){
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
        builder.header.subject = "EMAIL VERIFICATION-AUTOPARK_GOATS"
        builder.htmlBody="<p>Your email verification code is \(verificationCode)</p>"
        
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
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
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
