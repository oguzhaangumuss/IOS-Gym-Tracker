//
//  userMealViewModel.swift
//  fitnessApp
//
//  Created by oguzhangumus on 27.05.2024.
//

/*
import Foundation
import Firebase

class UserMealNetwork: Network {
    
    func addUserMeal(userMealData: [String: Any], completion: @escaping (Error?) -> Void) {
        var ref: DocumentReference? = nil
        ref = db.collection("userMeals").addDocument(data: userMealData) { error in
            completion(error)
        }
    }
    
    func deleteUserMeal(mealID: String, completion: @escaping (Error?) -> Void) {
        let mealRef = db.collection("userMeals").document(mealID)
        mealRef.delete { error in
            completion(error)
        }
    }
    
    func fetchUserMeals(forUserID userID: String, completion: @escaping ([UserMeal]?, Error?) -> Void) {
        db.collection("userMeals")
            .whereField("userId", isEqualTo: userID)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion(nil, error)
                } else {
                    let userMeals = querySnapshot?.documents.compactMap { document in
                        try? document.data(as: UserMeal.self)
                    } ?? []
                    completion(userMeals, nil)
                }
        }
    }
    
    func updateUserMeal(mealID: String, userMealData: [String: Any], completion: @escaping (Error?) -> Void) {
        let mealRef = db.collection("userMeals").document(mealID)
        mealRef.updateData(userMealData) { error in
            completion(error)
        }
    }
    
    // Diğer fonksiyonlar eklenebilir...
}

*/
