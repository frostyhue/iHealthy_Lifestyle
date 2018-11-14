//
//  SingleExerciseViewController.swift
//  iHealthyLifestyle
//
//  Created by ISSD on 11/04/2018.
//  Copyright © 2018 ISSD. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SingleExerciseViewController: UIViewController {
    var ref: DatabaseReference!
    var workoutIndex: String!
    var exInFavorites = false
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var muscleGroups: UILabel!
    @IBOutlet weak var exDescription: UILabel!
    @IBOutlet weak var setsLb: UILabel!
    @IBOutlet weak var repsLb: UILabel!
    @IBOutlet weak var favoritesBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        workoutIndex = UserDefaults.standard.object(forKey: "DisplayExerciseWithId") as? String
        
        //displays the thingy indicating we the program is not stuck
        let activityIndic = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        activityIndic.center = view.center
        activityIndic.startAnimating()
        activityIndic.hidesWhenStopped = true
        view.addSubview(activityIndic)
        
        ref = Database.database().reference()

        ref.child("exercises").child(workoutIndex).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary

            let img = value?.value(forKey: "MuscleGroup") as? String
            
            if(img == "Back"){
                self.image.image = UIImage(named: "pullup")
            } else if(img == "Shoulders"){
                self.image.image = UIImage(named: "military press")
            } else {
                self.image.image = UIImage(named: "crunch")
            }
            
            self.title = value?.value(forKey: "Name") as? String
            
            self.muscleGroups.text = value?.value(forKey: "MuscleGroup") as? String
            self.exDescription.text = value?.value(forKey: "Description") as? String
            
            
            if let sets = value?.value(forKey: "Sets") as? Int {
                if let reps = value?.value(forKey: "Reps") as? Int{
                    self.setsLb.text = "\(sets) sets of \(reps) repetitions each"
                }
            }
            activityIndic.stopAnimating()

        }) { (error) in
            print(error.localizedDescription)
        }
        
        ref.child("user").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary

            if(value?.value(forKey: "favoriteEx") != nil){
                if let myVar = value?.value(forKey: "favoriteEx") as? [String]{
                    for i in myVar{
                        if(i == self.workoutIndex){
                            self.exInFavorites = true
                            break
                        }
                    }
                }
            }
            
            if(self.exInFavorites){
                self.favoritesBtn.title = "♥"
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    
        

    }

    @IBAction func favoriteButtonClick(_ sender: UIBarButtonItem) {
        var allFavs = [String]()
        if(exInFavorites){
            ref.child("user").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                
                if(value?.value(forKey: "favoriteEx") != nil){
                    if let myVar = value?.value(forKey: "favoriteEx") as? [String]{
                        for i in myVar{
                            if(i != self.workoutIndex){
                                allFavs.append(i)
                            }
                        }
                    }
                }
                
                self.ref.child("user").child((Auth.auth().currentUser?.uid)!).child("favoriteEx").setValue(allFavs)
                
                allFavs.removeAll()
                
                self.displayMsg(msg: "Exercise successfully removed from favorites!")
                self.favoritesBtn.title = "♡"
                self.exInFavorites = false
            }) { (error) in
                print(error.localizedDescription)
            }
        } else {
            ref.child("user").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                
                if(value?.value(forKey: "favoriteEx") != nil){
                    if let myVar = value?.value(forKey: "favoriteEx") as? [String]{
                        for i in myVar{
                            allFavs.append(i)
                        }
                    }
                }
                
                if(!allFavs.contains(self.workoutIndex)){
                    allFavs.append(self.workoutIndex)
                }
                
                self.ref.child("user").child((Auth.auth().currentUser?.uid)!).child("favoriteEx").setValue(allFavs)
                
                allFavs.removeAll()
                
                self.displayMsg(msg: "Exercise successfully added to favorites!")
                self.favoritesBtn.title = "♥"
                self.exInFavorites = true
            }) { (error) in
                print(error.localizedDescription)
            }
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
