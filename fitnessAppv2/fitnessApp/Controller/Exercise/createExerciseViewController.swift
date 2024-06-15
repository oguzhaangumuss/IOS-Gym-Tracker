//
//  createExerciseViewController.swift
//  fitnessApp
//
//  Created by oguzhangumus on 20.05.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
class createExerciseViewController: UIViewController {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var exerciseNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.descriptionTextView.text = ""
               }
    }
    
    
    @IBAction func createExerciseClicked(_ sender: Any) {
        if exerciseNameTextField.text != "" && descriptionTextView.text != "" {
            let newExerciseDictionary = [
                "name": self.exerciseNameTextField.text!,
                "description": self.descriptionTextView.text!
            ]
            
            let firestore = Firestore.firestore()
            firestore.collection("exercises").addDocument(data: newExerciseDictionary) { error in
                if let error = error {
                    print("Egzersiz eklenirken hata oluştu: \(error.localizedDescription)")
                    AlertHelper.shared.showAlert(from: self, title: "Error", message: "An error occurred while creating a new exercise.")
                } else {
                    self.descriptionTextView.text = ""
                    self.exerciseNameTextField.text = ""
                    AlertHelper.shared.showAlert(from: self, title: "Success", message: "New Exercise Added Successfully")
                }
            }
        } else {
            AlertHelper.shared.showAlert(from: self, title: "Warning", message: "Please fill in all fields!")
        }
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}



