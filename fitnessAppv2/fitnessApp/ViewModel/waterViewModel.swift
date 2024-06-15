//
//  waterViewModel.swift
//  fitnessApp
//
//  Created by oguzhangumus on 26.05.2024.
//
/*
import Foundation
import Firebase

class WaterNetowk : Network{
    func addWater(waterData: [String: Any], completion: @escaping (Error?) -> Void) {
        var ref: DocumentReference? = nil
        ref = db.collection("waters").addDocument(data: waterData) { error in
            completion(error)
        }
        
    }
    
    func updateWater(waterID: String, waterData: [String: Any], completion: @escaping (Error?) -> Void) {
        let waterRef = db.collection("waters").document(waterID)
        waterRef.updateData(waterData) { error in
            completion(error)
        }
    }
    
    func fetchWaters(completion: @escaping ([Water]?, Error?) -> Void) {
        db.collection("waters").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(nil, error)
            } else {
                let waters = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Water.self)
                } ?? []
                completion(waters, nil)
            }
        }
    }
    
    func deleteWater(waterID: String, completion: @escaping (Error?) -> Void) {
        let waterRef = db.collection("waters").document(waterID)
        waterRef.delete { error in
            completion(error)
        }
    }
}
*/
