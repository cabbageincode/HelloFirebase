//
//  LoginViewController.swift
//  HelloFirebase
//
//  Created by cabbage on 02/08/2017.
//  Copyright © 2017 cabbage. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    //segue identifiers
    static private let kSegueShowNext = "seguePushEditor"
    
    @IBOutlet weak var mailTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField?
    
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        
        guard let mail = mailTextField?.text else {
            return;
        }
        
        guard let password = passwordTextField?.text else {
            return;
        }
        
        Auth.auth().createUser(withEmail: mail, password: password) { (user, error) in
            
            if error != nil {
                print("error >> \(String(describing: error))")
            } else if user != nil {                
                self.performSegue(withIdentifier: LoginViewController.kSegueShowNext, sender: nil);
            }
        }
    }
    
    @IBAction func loginButtonClicked(sender: UIButton) {
        
        guard let mail = mailTextField?.text else {
            return;
        }
        
        guard let password = passwordTextField?.text else {
            return;
        }
        
        Auth.auth().signIn(withEmail: mail, password: password) { (user, error) in
            
            guard error == nil else {
                //error handler
                print("login failed... \(error.debugDescription)")
                return;
            }
            
            guard let signInUser = user else {
                return;
            }
            
            self.dismiss(animated: true, completion: nil)
            print("user id >> \(signInUser.uid)")
            
            /*
            signInUser.sendEmailVerification(completion: { (error) in
             
                guard error == nil else {
                    //
                    print("send mail error \(error.debugDescription)")
                    return;
                }
            })
            */
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - private
    
}


