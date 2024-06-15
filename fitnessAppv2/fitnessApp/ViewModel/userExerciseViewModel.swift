//
//  userExerciseViewModel.swift
//  fitnessApp
//
//  Created by oguzhangumus on 26.05.2024.
//

import Foundation
import Firebase

class UserExerciseNetwork : Network {
    
    func deleteUserExercise(exerciseID: String, completion: @escaping (Error?) -> Void) {
        let exerciseRef = db.collection("userExercises").document(exerciseID)
        exerciseRef.delete { error in
            completion(error)
        }
    }
    
    func fetchUserExercises(forUserID userID: String, completion: @escaping ([userExercise]?, Error?) -> Void) {
            db.collection("userExercises")
                .whereField("userId", isEqualTo: userID) // Kullanıcı kimliğine göre filtrele
                .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion(nil, error)
                } else {
                    let userExercises = querySnapshot?.documents.compactMap { document in
                        try? document.data(as: userExercise.self)
                    } ?? []
                    completion(userExercises, nil)
                }
            }
        }
    func updateUserExercise(exerciseID: String, userExerciseData: [String: Any], completion: @escaping (Error?) -> Void) {
            let exerciseRef = db.collection("userExercises").document(exerciseID)
            exerciseRef.updateData(userExerciseData) { error in
                completion(error)
            }
        }
    
}



