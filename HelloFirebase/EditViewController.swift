//
//  EditViewController.swift
//  HelloFirebase
//
//  Created by cabbage on 04/08/2017.
//  Copyright © 2017 cabbage. All rights reserved.
//

import UIKit
import FirebaseAuth

class EditViewController: UIViewController {

    private var currentUser: User? = nil
    
    @IBOutlet weak var nameTextField: UITextField?
    @IBOutlet weak var descTextField: UITextField?
    
    @IBAction func saveButtonClicked(sender: UIButton) {
        
        guard self.currentUser != nil else {
            return
        }
        
        let user = HFUser(token: self.currentUser!.uid)
        
        if let name = self.nameTextField?.text {
            user.name = name
        }
        
        if let desc = self.descTextField?.text {
            user.desc = desc
        }
        
        HFFirebaseDataManager.sharedInstance().saveUser(newUser: user)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard Auth.auth().currentUser != nil else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        self.currentUser = Auth.auth().currentUser!
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

}
