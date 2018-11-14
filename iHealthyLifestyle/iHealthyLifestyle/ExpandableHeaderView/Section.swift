//
//  Section.swift
//  iHealthyLifestyle
//
//  Created by ISSD on 12/04/2018.
//  Copyright © 2018 ISSD. All rights reserved.
//

import Foundation

struct Section{
    var typeOfWorkout: String!
    var workouts: [String]!
    var expanded: Bool!
    
    init(type: String, workouts: [String], expanded: Bool){
        self.typeOfWorkout = type
        self.workouts = workouts
        self.expanded = expanded
    }
}
