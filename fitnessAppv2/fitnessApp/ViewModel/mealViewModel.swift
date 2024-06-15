//
//  mealViewModel.swift
//  fitnessApp
//
//  Created by oguzhangumus on 26.05.2024.
//

import Foundation
import Firebase

class MealNetwork : Network {
    
    func addMeal(meal: Meal, completion: @escaping (Error?) -> Void) {
            do {
                _ = try db.collection("meals").addDocument(from: meal, completion: { error in
                    completion(error)
                })
            } catch let error {
                completion(error)
            }
        }

    func updateMeal(mealID: String, mealData: [String: Any], completion: @escaping (Error?) -> Void) {
            let mealRef = db.collection("meals").document(mealID)
            mealRef.updateData(mealData) { error in
                completion(error)
            }
        }

    func fetchMeals(forUser userID: String, completion: @escaping ([Meal]?, Error?) -> Void) {
        db.collection("meals")
            .whereField("userId", isEqualTo: userID) // Sadece belirli bir kullanıcının yemeklerini al
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion(nil, error)
                } else {
                    let meals = querySnapshot?.documents.compactMap { document in
                        try? document.data(as: Meal.self)
                    } ?? []
                    completion(meals, nil)
                }
        }
    }

    func deleteMeal(mealID: String, completion: @escaping (Error?) -> Void) {
            let mealRef = db.collection("meals").document(mealID)
            mealRef.delete { error in
                completion(error)
            }
        }
    func deleteFoodFromMeal(mealID: String, foodID: String, completion: @escaping (Error?) -> Void) {
        let mealRef = db.collection("meals").document(mealID)
        mealRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if var mealData = document.data(), var foods = mealData["foods"] as? [[String: Any]] {
                    // "foods" alanı var ve nil değilse
                    foods.removeAll { ($0["id"] as? String) == foodID }
                    mealData["foods"] = foods
                    mealRef.setData(mealData) { error in
                        completion(error)
                    }
                } else {
                    // "foods" alanı nil veya dökümanın içinde yok
                    print("Foods data not found or nil")
                    completion(nil) // Silme işlemi başarılı kabul edildi
                }
            } else {
                // Belirtilen mealID'ye sahip döküman yok
                print("Document does not exist")
                //completion(error) // Hata bildir (Silme işlemi hatasız olduğu için nil gönder)
                completion(nil) // Hata bildirme
            }
        }
    }



    
}
