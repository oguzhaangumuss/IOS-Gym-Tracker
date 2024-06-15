//
//  exerciseViewModel.swift
//  fitnessApp
//
//  Created by oguzhangumus on 26.05.2024.
//

import Foundation
import Firebase

class ExerciseNetwork : Network{
    
    func fetchExercises(completion: @escaping ([Exercise]?, Error?) -> Void) {
        db.collection("exercises").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(nil, error)
            }
            else {
                let exercises = querySnapshot?.documents.compactMap {
                    document in
                    try? document.data(as: Exercise.self)
                } ?? []
                completion(exercises, nil)
            }
        }
    }
     
     }
