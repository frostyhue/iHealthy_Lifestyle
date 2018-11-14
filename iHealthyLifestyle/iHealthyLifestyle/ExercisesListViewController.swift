//
//  ExercisesListViewController.swift
//  iHealthyLifestyle
//
//  Created by ISSD on 11/04/2018.
//  Copyright © 2018 ISSD. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ExercisesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var ref: DatabaseReference!
    var exercisesToDisplay = [String]()
    var exerciseForGroup = [String]()
    var exerciseIds = [String]()
    @IBOutlet weak var myTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tempArray = UserDefaults.standard.object(forKey: "MuscleGroupsExercizesDisplay") as? [String] ?? [String]()

        ref = Database.database().reference()
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 42))
        label.center = CGPoint(x: 160, y: 284)
        label.textAlignment = NSTextAlignment.center
        label.text = "Nothing to display."
        self.view.addSubview(label)
        label.isHidden = true
        
        let activityIndic = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        activityIndic.center = view.center
        activityIndic.startAnimating()
        activityIndic.hidesWhenStopped = true
        view.addSubview(activityIndic)
        
        ref.child("exercises").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            for i in value!{
                
                self.ref.child("exercises").child("\(i.key)").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    
                    if let group = value?.value(forKey: "MuscleGroup") as? String{
                        if(tempArray.contains(group)){
                            self.exercisesToDisplay.append((value?.value(forKey: "Name") as? String)!)
                            self.exerciseForGroup.append(group)
                            self.exerciseIds.append("\(i.key)")
                        }
                    }
                    
                    if(self.exercisesToDisplay.count == 0){
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
        return exercisesToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //ExerciseSelectorCell
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseSelectorCell", for:indexPath) as! ExerciseSelectorTableViewCell
        
        cell.nameLb.text = self.exercisesToDisplay[indexPath.row]
        cell.groupsLb.text = self.exerciseForGroup[indexPath.row]
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let defaults = UserDefaults.standard
        defaults.set(exerciseIds[indexPath.row], forKey: "DisplayExerciseWithId")
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
