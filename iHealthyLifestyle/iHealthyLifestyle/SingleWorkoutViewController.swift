//
//  SingleWorkoutViewController.swift
//  iHealthyLifestyle
//
//  Created by ISSD on 12/04/2018.
//  Copyright © 2018 ISSD. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SingleWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var ref: DatabaseReference!
    var exercisesNames = [String]()
    var reps = [String]()
    var sets = [String]()
    var groups = [String]()
    var userAnswer = [Int]()
    var workoutIndex: String!
    var exerciseIds = [String]()
    var exInFavorites = false
    var appDelegate = UIApplication.shared.delegate as? AppDelegate

    @IBOutlet weak var btNotify: UIButton!
    @IBAction func btNotificationSet(_ sender: Any) {
        appDelegate?.scheduleNotification()
    }
    
    @IBOutlet weak var favoritesBtn: UIBarButtonItem!
    @IBOutlet weak var muscleGroupsLb: UILabel!
    @IBOutlet weak var myTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activityIndic = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        activityIndic.center = view.center
        activityIndic.startAnimating()
        activityIndic.hidesWhenStopped = true
        view.addSubview(activityIndic)

        
        workoutIndex = UserDefaults.standard.object(forKey: "DisplayWorkoutWithId") as? String
  
        ref = Database.database().reference()
        muscleGroupsLb.text = ""
        
        ref.child("workouts").child(workoutIndex).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if let grps = value?.value(forKey: "groups") as? [String]{
                for g in grps{
                    self.muscleGroupsLb.text =  self.muscleGroupsLb.text! + g + " "
                }
            }
            
            self.title = value?.value(forKey: "name") as? String
            
            if let exrcs = value?.value(forKey: "exercises") as? [String]{
                for e in exrcs{
                    self.ref.child("exercises").child(e).observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        if let name = value?.value(forKey: "Name") as? String{
                            if let group = value?.value(forKey: "MuscleGroup") as? String{
                                if let reps = value?.value(forKey: "Reps") as? Int{
                                    if let sets = value?.value(forKey: "Sets") as? Int{
                                        self.reps.append("\(reps)")
                                        self.sets.append("\(sets)")
                                        self.exercisesNames.append(name)
                                        self.groups.append(group)
                                        self.exerciseIds.append(e)
                                    }
                                }
                            }
                        }
                        
                        activityIndic.stopAnimating()
                        
                        DispatchQueue.main.async {
                            self.myTable.reloadData()
                        }
                    })
                }
            }
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        ref.child("user").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if(value?.value(forKey: "favoriteWrk") != nil){
                if let myVar = value?.value(forKey: "favoriteWrk") as? [String]{
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercisesNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExInWCell", for:indexPath) as! ExercisesInWorkoutTableViewCell
        
        cell.exNameLb.text = exercisesNames[indexPath.row]
        cell.srepsXsetsLb.text = "\(sets[indexPath.row]) sets x \(reps[indexPath.row]) reps"
        cell.groupsLb.text = groups[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 54
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let defaults = UserDefaults.standard
        defaults.set(exerciseIds[indexPath.row], forKey: "DisplayExerciseWithId")
    }
    
    @IBAction func favoriteButtonClick(_ sender: UIBarButtonItem) {
        var allFavs = [String]()
        if(exInFavorites){
            ref.child("user").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                
                if(value?.value(forKey: "favoriteWrk") != nil){
                    if let myVar = value?.value(forKey: "favoriteWrk") as? [String]{
                        for i in myVar{
                            if(i != self.workoutIndex){
                                allFavs.append(i)
                            }
                        }
                    }
                }
                
                self.ref.child("user").child((Auth.auth().currentUser?.uid)!).child("favoriteWrk").setValue(allFavs)
                
                allFavs.removeAll()
                
                self.displayMsg(msg: "Workout successfully removed from favorites!")
                self.favoritesBtn.title = "♡"
                self.exInFavorites = false
            }) { (error) in
                print(error.localizedDescription)
            }
        } else {
            ref.child("user").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                
                if(value?.value(forKey: "favoriteWrk") != nil){
                    if let myVar = value?.value(forKey: "favoriteWrk") as? [String]{
                        for i in myVar{
                            allFavs.append(i)
                        }
                    }
                }
                
                if(!allFavs.contains(self.workoutIndex)){
                    allFavs.append(self.workoutIndex)
                }
                
                self.ref.child("user").child((Auth.auth().currentUser?.uid)!).child("favoriteWrk").setValue(allFavs)
                
                allFavs.removeAll()
                
                self.displayMsg(msg: "Workout successfully added to favorites!")
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
