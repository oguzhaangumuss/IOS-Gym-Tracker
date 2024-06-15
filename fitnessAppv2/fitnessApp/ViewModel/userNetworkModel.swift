//
//  userNetwork.swift
//  fitnessApp
//
//  Created by oguzhangumus on 27.05.2024.
//

import Foundation
import Firebase

class UserNetwork : Network {
    
    func fetchUserInfo(forUserID userID: String , completion:@escaping ([User]?,Error?) -> Void) {
        db.collection("userInfo")
            .whereField("userID", isEqualTo: userID)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print ("fetching userinfo hatası: \(error.localizedDescription)")
                    completion(nil,error)
                } else {
                    let userInfo = querySnapshot?.documents.compactMap {
                        document in
                        try? document.data (as: User.self)
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
    
}
