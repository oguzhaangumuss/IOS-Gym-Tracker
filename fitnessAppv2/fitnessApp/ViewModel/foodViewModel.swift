//
//  foodViewModel.swift
//  fitnessApp
//
//  Created by oguzhangumus on 26.05.2024.
//

import Foundation
import Firebase

class FoodNetwork : Network{
    
    func addFood(food: Food, completion: @escaping (Error?) -> Void) {
            do {
                _ = try db.collection("foods").addDocument(from: food, completion: { error in
                    completion(error)
                })
            } catch let error {
                completion(error)
            }
        }

    func updateFood(foodID: String, foodData: [String: Any], completion: @escaping (Error?) -> Void) {
            let foodRef = db.collection("foods").document(foodID)
            foodRef.updateData(foodData) { error in
                completion(error)
            }
        }

    func fetchFoods(completion: @escaping ([Food]?, Error?) -> Void) {
            db.collection("foods").getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion(nil, error)
                } else {
                    let foods = querySnapshot?.documents.compactMap { document in
                        try? document.data(as: Food.self)
                    } ?? []
                    completion(foods, nil)
                }
            }
        }

    func deleteFood(foodID: String, completion: @escaping (Error?) -> Void) {
        let foodRef = db.collection("foods").document(foodID)
        foodRef.delete { error in
            completion(error)
        }
    }

    
}
