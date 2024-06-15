//
//  ViewController.swift
//  fitnessApp
//
//  Created by oguzhangumus on 9.05.2024.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController  {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.autocorrectionType = .no
        
    }
    
    @IBAction func signInClicked(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            AlertHelper.shared.showAlert(from: self, title: "Warning!", message: "Please fill in all fields!")
            return
        }
        AuthManager.shared.SignIn(email: email, password: password){[weak self] success in
            guard success else {
                AlertHelper.shared.showAlert(from: self!, title: "Warning!", message: "Please Check Your Email and Password!")
                return
            }
            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set(password, forKey: "password")
            self?.performSegue(withIdentifier: "toTabVC", sender: nil)
        }
    }
        
    
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            AlertHelper.shared.showAlert(from: self, title: "Warning!", message: "Please fill in all fields!")
            return
        } // Create User
        AuthManager.shared.SignUp(email: email, password: password) { [weak self]success in
            if success {
                // Update database
                let newUser = User(
                    userName: nil,
                    userLastName: nil,
                    userPassword: password,
                    userEmail: email,
                    userPhone: nil,
                    userRegistrationDate: Date(),
                    userMembershipType: nil,
                    userMembershipDuration: nil)
                DatabaseManager.shared.insertUser(user: newUser) {inserted in
                    guard inserted else {
                        
                        return
                    }
                    self?.performSegue(withIdentifier: "toTabVC", sender: nil)
                }
            } else {
                AlertHelper.shared.showAlert(from: self!, title: "Error", message: "Failed to create account!")
            }
                
        }
          
        
     
            }
        
    
    /*
    @IBAction func signUpClicked(_ sender: Any) {
            guard let email = usernameTextField.text, !email.isEmpty,
                  let password = passwordTextField.text, !password.isEmpty else {
                AlertHelper.shared.showAlert(from: self, title: "Warning!", message: "Please fill in all fields!")
                return
            }
            
            Auth.auth().createUser(withEmail: email, password: password) { [weak self]
                (authResult, error) in
                if let error = error {
                    print("Error creating user: \(error.localizedDescription)")
                    AlertHelper.shared.showAlert(from: self!, title: "Error", message: "An error occurred while signing up. Please try again.")
                    return
                }
                
                guard let authResult = authResult else { return }
                let userID = authResult.user.uid
                
                let userInfo = User(userId: userID,
                                        userName: "", // Kullanıcının adı
                                        userLastName: "", // Kullanıcının soyadı
                                        userPassword: password,
                                        userEmail: email,
                                        userPhone: "", // Kullanıcının telefon numarası
                                        userRegistrationDate: Date(),
                                        userMembershipType: "", // Kullanıcının üyelik tipi
                                        userMembershipDuration: "") // Kullanıcının üyelik süresi
                
                let firestore = Firestore.firestore()
                firestore.collection("userInfo").document(userID).setData(userInfo.dictionary) { error in
                    if let error = error {
                        print("Error saving user to database: \(error.localizedDescription)")
                        AlertHelper.shared.showAlert(from: self!, title: "Error", message: "User could not be saved to the database. Please try again later.")
                        return
                    }
                    AlertHelper.shared.showAlert(from: self!, title: "Success", message: "Sign up successful! Please sign in!")
                }
            }
        }
    */
}
