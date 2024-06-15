//
//  SettingsViewController.swift
//  fitnessApp
//
//  Created by oguzhangumus on 9.05.2024.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userMembershipDuration: UITextField!
    @IBOutlet weak var userMembershipType: UITextField!
    @IBOutlet weak var userRegistrationDate: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPhone: UITextField!
    @IBOutlet weak var userLastName: UITextField!
    @IBOutlet weak var userName: UITextField!
    
    var userNetwork = UserNetwork()
    let network = Network()
    var userInfo = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard Auth.auth().currentUser != nil else {
            // Kullanıcı oturumu açık değil, giriş ekranına yönlendirin
            self.performSegue(withIdentifier: "toSignInVC", sender: nil)
            return
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        showUserInfo()
    }
    
    @IBAction func updateClicked(_ sender: Any) {
        if userPassword.text != "" &&
        userMembershipType.text != "" &&
        userName.text != "" &&
        userPhone.text != "" &&
        userLastName.text != "" {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var userData: [String: Any] = [:]
        
        if let userName = userName.text, !userName.isEmpty {
            userData["userName"] = userName
        }
        
        if let userLastName = userLastName.text, !userLastName.isEmpty {
            userData["userLastName"] = userLastName
        }
        
        if let userPassword = userPassword.text, !userPassword.isEmpty {
            userData["userPassword"] = userPassword
        }
        
        if let userEmail = userEmail.text, !userEmail.isEmpty {
            userData["userEmail"] = userEmail
        }
        
        if let userPhone = userPhone.text, !userPhone.isEmpty {
            userData["userPhone"] = userPhone
        }
        
        if let userMembershipType = userMembershipType.text, !userMembershipType.isEmpty {
            userData["userMembershipType"] = userMembershipType
        }
        
        if let userMembershipDurationString = userMembershipDuration.text,
           let userMembershipDuration = Int(userMembershipDurationString) {
            userData["userMembershipDuration"] = userMembershipDuration
        }
        
            userNetwork.updateUser(uid: uid, userData: userData) { error in
            if let error = error {
                print("Error updating user: \(error.localizedDescription)")
                AlertHelper.shared.showAlert(from: self, title: "Error", message: "An error occurred while updating. Please try again later.")
            } else {
                AlertHelper.shared.showAlert(from: self, title: "Success", message: "User information updated successfully!")
                self.showUserInfo()
            }
        }
        } else {
            AlertHelper.shared.showAlert(from: self, title: "Error", message: "Please fill in all fields!")
        }
    }
    
    @IBAction func LogOutClicked(_ sender: Any) {
        AuthManager.shared.SignOut { success in
            if success {
                UserDefaults.standard.set(nil, forKey: "email")
                UserDefaults.standard.set(nil, forKey: "password")
                self.performSegue(withIdentifier: "toSignInVC", sender: nil)
            } 
        }
    }
    
    
    
    func showUserInfo() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No user ID found.")
            return
        }
        print(currentUserID)
        
        userNetwork.fetchUserInfo(forUserID: currentUserID) { [weak self] userInfo, error in
            if let error = error {
                print("Error fetching user info: \(error)")
            } else if let userInfo = userInfo, let currentUser = userInfo.first {
                DispatchQueue.main.async { [weak self] in
                    print(userInfo, currentUser)
                    self?.userPassword.text = currentUser.userPassword
                    self?.userName.text = currentUser.userName
                    self?.userLastName.text = currentUser.userLastName
                    self?.userEmail.text = currentUser.userEmail
                    self?.userPhone.text = currentUser.userPhone
                    self?.userMembershipType.text = currentUser.userMembershipType
                    if let duration = currentUser.userMembershipDuration {
                        self?.userMembershipDuration.text = String(duration)
                    }
                    // userRegistrationDate.text değeri nasıl doldurulacak, bu bilgi Firestore'da mı saklanıyor?
                }
            } else {
                
                print("Current user's information could not be found.")
            }
        }
    }

}








