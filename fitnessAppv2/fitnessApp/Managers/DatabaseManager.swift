//
//  DatabaseManager.swift
//  fitnessApp
//
//  Created by oguzhangumus on 27.05.2024.
//

import Foundation
import FirebaseFirestore

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Firestore.firestore()
    
    private init() {}
    
    public func insertUser(
        user: User,
        completion: @escaping (Bool) -> Void
    ) {
         let documentId = user.userEmail
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        let data = [
            "email" : user.userEmail,
            "password": user.userPassword,
            "userName": user.userName,
            "userLastName": user.userLastName,
            "userPhone": user.userPhone,
            "membershipType": user.userMembershipType,
            "date": Date()
        ] as [String : Any]
        database
            .collection("users")
            .document(documentId)
            .setData(data) { error in
                completion(error == nil)
            }
        
    }
    
    public func getAllExercises(
        completion: @escaping ([Exercise]) -> Void
    ) {
        
    }
    public func getExerciseForUser(
        for user: User,
        completion: @escaping ([Exercise]) -> Void
    ) {
        
    }
    
    public func insertExercise(
        exercise: Exercise,
        completion: @escaping (Bool) -> Void
    ) {
        
    }
    
    public func getFoods(completion: @escaping (Food?) -> Void ) {
        
    }
}
