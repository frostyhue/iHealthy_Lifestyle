//
//  AuthViewController.swift
//  iHealthyLifestyle
//
//  Created by ISSD on 10/04/2018.
//  Copyright © 2018 ISSD. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AuthViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var emailTb: UITextField!
    @IBOutlet weak var passwordTb: UITextField!
    
    //MARK: Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginBtnClick(_ sender: UIButton) {
        if((emailTb.text?.isEmpty)! || (passwordTb.text?.isEmpty)!){
            self.displayMsg(msg: "Please at least fill in all fields.")
            return;
        }
        
        Auth.auth().signIn(withEmail: emailTb.text!, password: passwordTb.text!) { (user, error) in
            if user != nil{
                let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let centerViewController = mainStoryboard.instantiateViewController(withIdentifier: "ExercisesViewController") as! ExercisesViewController
                
                let leftViewController = mainStoryboard.instantiateViewController(withIdentifier: "LeftSideViewController") as! LeftSideViewController
                
                let leftSideNav = UINavigationController(rootViewController: leftViewController)
                let centerNav = UINavigationController(rootViewController: centerViewController)
                
                appDelegate.centerContainer = MMDrawerController(center: centerNav, leftDrawerViewController: leftSideNav)
                
                appDelegate.centerContainer?.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView
                appDelegate.centerContainer?.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView
                
                appDelegate.window!.rootViewController = appDelegate.centerContainer
                appDelegate.window!.makeKey()
            } else {
                if let myError = error?.localizedDescription{
                    self.displayMsg(msg: myError)
                } else{
                    self.displayMsg(msg: "Unknown error.")
                }
            }
        }
        
    }
    
    
    @IBAction func regBtnClick(_ sender: UIButton) {
        if((emailTb.text?.isEmpty)! || (passwordTb.text?.isEmpty)!){
            displayMsg(msg: "Please at least fill in all fields.")
            return;
        }
        
        Auth.auth().createUser(withEmail: emailTb.text!, password: passwordTb.text!, completion: { (user, error) in
            if user != nil {
                let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                //let rootViewController = appDelegate.window!.rootViewController
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let centerViewController = mainStoryboard.instantiateViewController(withIdentifier: "ExercisesViewController") as! ExercisesViewController
                
                let leftViewController = mainStoryboard.instantiateViewController(withIdentifier: "LeftSideViewController") as! LeftSideViewController
                
                let leftSideNav = UINavigationController(rootViewController: leftViewController)
                let centerNav = UINavigationController(rootViewController: centerViewController)
                
                appDelegate.centerContainer = MMDrawerController(center: centerNav, leftDrawerViewController: leftSideNav)
                
                appDelegate.centerContainer?.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView
                appDelegate.centerContainer?.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView
                                
                appDelegate.window!.rootViewController = appDelegate.centerContainer
                appDelegate.window!.makeKey()
            } else {
                if let myError = error?.localizedDescription{
                    self.displayMsg(msg: myError)
                } else{
                    self.displayMsg(msg: "Unknown error.")
                }
            }
        })
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
