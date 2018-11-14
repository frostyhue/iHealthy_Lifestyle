//
//  ExercisesViewController.swift
//  iHealthyLifestyle
//
//  Created by ISSD on 10/04/2018.
//  Copyright © 2018 ISSD. All rights reserved.
//

import UIKit
import Firebase

class ExercisesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dbRef: DatabaseReference!
    
    var muscleGroups:[String] = ["Quadriceps", "Hamstrings", "Calves","Chest", "Back", "Shoulders", "Triceps", "Biceps", "Forearms", "Trapezius", "Abs"];
    
    var muscleGroupsToLookFor = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return muscleGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "CheckboxCell", for: indexPath) as! CheckboxTableViewCell
        
        myCell.CheckboxClickableCell.text = muscleGroups[indexPath.row]
        
        return myCell
    }
    
    //table item on click
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath as IndexPath){
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
                muscleGroupsToLookFor.remove(at: muscleGroupsToLookFor.index(of: muscleGroups[indexPath.row])!)
            } else {
                cell.accessoryType = .checkmark
                muscleGroupsToLookFor.append(muscleGroups[indexPath.row])
            }
        }
    }
    
    @IBAction func showWorkoutsOnClick(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.set(muscleGroupsToLookFor, forKey: "MuscleGroupsWorkoutsDisplay")
    }
    //list of exercise names to send
    var exerciseList = [String]()
    static var exId = [Int]()
    var doneLoading: Bool = false
    
    
    @IBAction func showExercisesOnClick(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        if(muscleGroupsToLookFor.count != 0){
            defaults.set(muscleGroupsToLookFor, forKey: "MuscleGroupsExercizesDisplay")
        } else {
            defaults.set(muscleGroups, forKey: "MuscleGroupsExercizesDisplay")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
