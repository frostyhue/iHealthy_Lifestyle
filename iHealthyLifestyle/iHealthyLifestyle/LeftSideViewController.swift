//
//  LeftSideViewController.swift
//  iHealthyLifestyle
//
//  Created by ISSD on 10/04/2018.
//  Copyright © 2018 ISSD. All rights reserved.
//

import UIKit
import FirebaseAuth

class LeftSideViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var menuItems:[String] = ["Exercises and Workouts", "My Workouts","Overview", "Log Out"];
    
    @IBOutlet weak var usernameLb: UILabel!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuItems.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NavDrawerCell", for: indexPath) as!  NavDrawerTableViewCell
        cell.NavDrawerClickableCell.text = menuItems[indexPath.row]
        
        return cell
    }
    
    
    //called on click
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        switch(indexPath.row){
        case 0:
            let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "ExercisesViewController") as! ExercisesViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController = centerNavController
            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            break;
        case 1:
            let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarCtrl") as! UITabBarController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController = centerNavController
            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            break;
        case 3:
            
            do{
                try Auth.auth().signOut()
            } catch {
                self.displayMsg(msg: "Unexpected error: \(error).")
            }
            
            let authViewCtrl = self.storyboard?.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
            
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate

            appDelegate.window?.rootViewController = authViewCtrl
            break;
        default:
            break;
        }
    }
    
    func displayMsg(msg: String) -> Void{
        DispatchQueue.main.async {
            let alertCtrl = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action: UIAlertAction!) in
                //triggered when ok button is pressed
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
            alertCtrl.addAction(OKAction)
            self.present(alertCtrl, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLb.text = Auth.auth().currentUser?.email
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

}
