//
//  exerciseModel.swift
//  fitnessApp
//
//  Created by oguzhangumus on 18.05.2024.
//

import Foundation
import FirebaseFirestoreSwift

struct Exercise: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var description: String?
    var exerciseId: String?
}

struct userExercise: Identifiable,Codable {
    @DocumentID var id: String?
    var name: String
    var rep:String
    var set: String
    var weight: String
    var userId: String
    var date: Date?
    var userExerciseId : String?
}

struct User: Identifiable,Codable {
 @DocumentID var id: String?
 //var userId: String
 var userName : String?
 var userLastName: String?
 var userPassword : String
 var userEmail : String
 var userPhone : String?
 var userRegistrationDate : Date
 var userMembershipType : String?
 var userMembershipDuration : String?
 
 var dictionary: [String: Any] {
     [

 "userName": userName ?? "",
 "userLastName": userLastName ?? "",
 "userPassword": userPassword,
 "userEmail": userEmail,
 "userPhone": userPhone ?? "",
 "userRegistrationDate": userRegistrationDate,
 "userMembershipType": userMembershipType ?? "",
 "userMembershipDuration": userMembershipDuration ?? ""
     ]
    }
 }

struct Food: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String?
    var foodDescription: String?
    var amount: String?
    var calories: String?
    var protein: String?
    var fat: String?
    var carbohdrate: String?
    var sugar: String?
}

struct Meal: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String?
    var foods: [Food]?
    var mealName: String?
}


