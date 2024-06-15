//
//  network.swift
//  fitnessApp
//
//  Created by oguzhangumus on 20.05.2024.
//

import Foundation
import FirebaseFirestore

class Network {
    let db = Firestore.firestore()
    /*
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
    
    
    func fetchUserInfo(forUserID userID: String , completion:@escaping ([userInfos]?,Error?) -> Void) {
        db.collection("userInfo")
            .whereField("userID", isEqualTo: userID)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print ("fetching userinfo hatası: \(error.localizedDescription)")
                    completion(nil,error)
                } else {
                    let userInfo = querySnapshot?.documents.compactMap {
                        document in
                        try? document.data (as: userInfos.self)
                    } ?? []
                    
                    if userInfo.isEmpty {
                        print("No documents found for userID: \(userID)")
                        let fetchError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No documents found for userID"])
                        completion(nil, fetchError)
                    } else {
                        completion(userInfo, nil)
                    }
                }
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
    
      
    func deleteUserExercise(exerciseID: String, completion: @escaping (Error?) -> Void) {
        let exerciseRef = db.collection("userExercises").document(exerciseID)
        exerciseRef.delete { error in
            completion(error)
        }
    }
    
    func updateUser(uid: String, userData: [String: Any], completion: @escaping (Error?) -> Void) {
            let userRef = db.collection("userInfo").whereField("userID", isEqualTo: uid)
            
            userRef.getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(error)
                    return
                }
                
                guard let documents = querySnapshot?.documents, let document = documents.first else {
                    completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No document to update"]))
                    return
                }
                
                document.reference.updateData(userData) { error in
                    completion(error)
                }
            }
        }
    */
    
                    
}



