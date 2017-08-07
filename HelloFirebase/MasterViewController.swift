//
//  MasterViewController.swift
//  HelloFirebase
//
//  Created by cabbage on 02/08/2017.
//  Copyright © 2017 cabbage. All rights reserved.
//

import UIKit
import Firebase

class MasterViewController: UITableViewController {

    //segue identifiers
    static private let kSeguePresentLogin = "seguePresentLogin"
    static private let kSeguePresentEditor = "seguePresentEditor"
    
    var detailViewController: DetailViewController? = nil
    
    var loginUser: HFUser?
    var objectsInMyBag = [Dictionary<String, String>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let currentUser = Auth.auth().currentUser else {
            //not login
            self.performSegue(withIdentifier: MasterViewController.kSeguePresentLogin, sender: nil)
            return
        }
        
        let bagPathUrl = "https://my-first-in-firebase.firebaseio.com/Bags/" + currentUser.uid
        let bagRef = Database.database().reference(fromURL: bagPathUrl)
        /*
         //也可以寫成以下方法…
         let bagRef = Database.database().reference().child("Bags").child(currentUser.uid)
         */
        
        bagRef.observe(.childAdded, with: { (snapshot) in
            
            guard let object = snapshot.value as? Dictionary<String, String> else {
                return
            }
            
            self.objectsInMyBag.append(object)
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addObjectToMybag(name: String, desc: String) {
        
//        let bagPathUrl = "https://my-first-in-firebase.firebaseio.com/Bags/user_a"// + Auth.auth().currentUser!.uid
//        let bagRef = Database.database().reference(fromURL: bagPathUrl)

        let bagRef = Database.database().reference().child("Bags").child("user_a")
        
        let bagDict = ["name": "pen", "desc": "this is a pen"]
        
        bagRef.childByAutoId().setValue(bagDict) { (error, resultRef) in
            
            guard error == nil else {
                print("save bag object error... \(error.debugDescription)")
                return
            }
        }
    }

    func insertNewObject(_ sender: Any) {
        
        let alertVC = UIAlertController(title: "加一個物品到我的包包裡", message: nil, preferredStyle: .alert)
        alertVC.addTextField { (textField) in
            textField.placeholder = "物件名字"
        }
        alertVC.addTextField { (textField) in
            textField.placeholder = "敘述"
        }
        
        let addAction = UIAlertAction(title: "添加", style: .default) { (action) in
            
            guard let objectName = alertVC.textFields![0].text else {
                return
            }
            
            guard let objectDesc = alertVC.textFields![1].text else {
                return
            }
            
            self.addObjectToMybag(name: objectName, desc: objectDesc)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
            alertVC.dismiss(animated: true, completion: nil)
        }
        
        alertVC.addAction(addAction)
        alertVC.addAction(cancelAction)
        
        self.present(alertVC, animated: true) { 
            
        }
    }

    // MARK: - Segues

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDetail" {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                let object = objects[indexPath.row] as! NSDate
//                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.detailItem = object
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
//        }
//    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.objectsInMyBag.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = self.objectsInMyBag[indexPath.row]
        
        cell.textLabel!.text = object["name"]
        cell.detailTextLabel?.text = object["desc"]
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            objects.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

