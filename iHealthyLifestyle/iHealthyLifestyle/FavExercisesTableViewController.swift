//
//  FavExercisesTableViewController.swift
//  iHealthyLifestyle
//
//  Created by ISSD on 12/04/2018.
//  Copyright © 2018 ISSD. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class FavExercisesTableViewController: UITableViewController {
    var exercisesToShow = [String]()
    var exerciseIds = [String]()
    var muscleGroups = [String]()
    var ref: DatabaseReference!
    var favIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 284)
        label.textAlignment = NSTextAlignment.center
        label.text = "You don't seem to have any favorite exercises."
        self.view.addSubview(label)
        
        let activityIndic = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        activityIndic.center = view.center
        activityIndic.startAnimating()
        activityIndic.hidesWhenStopped = true
        view.addSubview(activityIndic)

     
        ref.child("user").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if(value?.value(forKey: "favoriteEx") != nil){
                if let myVar = value?.value(forKey: "favoriteEx") as? [String]{
                    for i in myVar{
                        self.favIds.append(i)
                    }
                }
            }
            
            for i in self.favIds{
                 self.ref.child("exercises").child(i).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    
                    if let name = value?.value(forKey: "Name") as? String{
                        if let group = value?.value(forKey: "MuscleGroup") as? String{
                            self.exercisesToShow.append(name)
                            self.muscleGroups.append(group)
                            self.exerciseIds.append(i)
                            label.isHidden = true
                            activityIndic.stopAnimating()
                        }
                    }
                    
                    self.tableView.reloadData()
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return exercisesToShow.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "favExerciseCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? FavExerciseTableViewCell else{
            fatalError("Cell not an instance of FavExerciseTableViewCell")
        }
        
        cell.nameLb.text = self.exercisesToShow[indexPath.row]
        cell.groupLb.text = self.muscleGroups[indexPath.row]

        return cell
    }
 
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let defaults = UserDefaults.standard
        defaults.set(exerciseIds[indexPath.row], forKey: "DisplayExerciseWithId")
        
        let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "SingleExerciseViewController") as! SingleExerciseViewController
        let centerNavController = UINavigationController(rootViewController: centerViewController)
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.centerContainer!.centerViewController = centerNavController
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
