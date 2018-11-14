//
//  WorkoutsListViewController.swift
//  iHealthyLifestyle
//
//  Created by ISSD on 11/04/2018.
//  Copyright © 2018 ISSD. All rights reserved.
//

import UIKit
import FirebaseDatabase

class WorkoutsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var myTable: UITableView!
    var workoutsToDisplay = [String]()
    var workoutsForGroup = [String]()
    var workoutIds = [String]()
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tempArray = UserDefaults.standard.object(forKey: "MuscleGroupsWorkoutsDisplay") as? [String] ?? [String]()
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 42))
        label.center = CGPoint(x: 160, y: 284)
        label.textAlignment = NSTextAlignment.center
        label.text = "Nothing to display."
        self.view.addSubview(label)
        label.isHidden = true
        
        ref = Database.database().reference()
        
        let activityIndic = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        activityIndic.center = view.center
        activityIndic.startAnimating()
        activityIndic.hidesWhenStopped = true
        view.addSubview(activityIndic)
        
        ref.child("workouts").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            for i in value!{
                self.ref.child("workouts").child("\(i.key)").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    
                    var groupsWorkoutHas = [String]()
                    var groupsWorkoutHasString = ""
                    if let myVar = value?.value(forKey: "groups") as? [String]{
                        for i in myVar{
                            groupsWorkoutHas.append(i)
                            groupsWorkoutHasString = groupsWorkoutHasString + i + " "
                        }
                    }
                 
                    var contained = true
                    for k in tempArray{
                        if(!groupsWorkoutHas.contains(k)){
                            contained = false
                        }
                    }
                    
                    if(contained){
                        self.workoutsToDisplay.append((value?.value(forKey: "name") as? String)!)
                        self.workoutsForGroup.append(groupsWorkoutHasString)
                        self.workoutIds.append("\(i.key)")
                    }
                    
                    if(self.workoutsToDisplay.count == 0){
                        label.isHidden = false
                    } else {
                        label.isHidden = true
                    }
                    
                    DispatchQueue.main.async {
                        self.myTable.reloadData()
                    }
                    
                    activityIndic.stopAnimating()
                }) { (error) in
                    print(error.localizedDescription)
                }
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
        return workoutsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //ExerciseSelectorCell
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutSelectorCell", for:indexPath) as! WorkoutSelectorTableViewCell
        
        cell.nameLb.text = self.workoutsToDisplay[indexPath.row]
        cell.groupsLb.text = self.workoutsForGroup[indexPath.row]
        
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let defaults = UserDefaults.standard
        defaults.set(workoutIds[indexPath.row], forKey: "DisplayWorkoutWithId")
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
