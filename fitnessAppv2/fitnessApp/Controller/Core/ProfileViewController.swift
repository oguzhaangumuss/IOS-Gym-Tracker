//
//  ProfileViewController.swift
//  fitnessApp
//
//  Created by oguzhangumus on 9.05.2024.
//
import UIKit
import FirebaseFirestore
import FirebaseAuth

class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var profileTableView: UITableView!
    
    var userExerciseNetwork = UserExerciseNetwork()
    var network = Network()
    let db = Firestore.firestore()
    var exercises = [Exercise]()
    var userExercises = [userExercise]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileTableView.dataSource = self
        self.profileTableView.delegate = self
        
        showUserExercises()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showUserExercises()
    }
    
    func showUserExercises() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("no user id")
            return
        }
        userExerciseNetwork.fetchUserExercises(forUserID: currentUserID) { [weak self] userExercises, error in
            if let error = error {
                print("Error fetching user exercises: \(error)")
            } else if let userExercises = userExercises {
                self?.userExercises = userExercises
                self?.profileTableView.reloadData()
            }
        }
    }
    
    
    
    @IBAction func deleteClicked(_ sender: Any) {
        guard let indexPath = profileTableView.indexPathForSelectedRow else {
            AlertHelper.shared.showAlert(from: self, title: "Warning!", message:"Make sure that tap a exercise name!" )
            return
        }
        
        let selectedExercise = userExercises[indexPath.row]
        print("selectedExercise.id")
        userExerciseNetwork.deleteUserExercise(exerciseID: selectedExercise.id ?? "") { error in
            if let error = error {
                print("Error deleting exercise: \(error.localizedDescription)")
                AlertHelper.shared.showAlert(from: self, title: "Error", message: "An error occurred while deleting the exercise. Please try again later.")
            } else {
                self.showUserExercises()
                AlertHelper.shared.showAlert(from: self, title: "Success", message: "Exercise deleted successfully!")
            }
        }
    }
    @IBAction func updateClicked(_ sender: Any) {
        guard let indexPath = profileTableView.indexPathForSelectedRow else {
            AlertHelper.shared.showAlert(from: self, title: "Warning!", message:"Make sure that tap a exercise name!" )
            return
        }
        
        guard let cell = profileTableView.cellForRow(at: indexPath) as? profileCell else {
            print("Unable to retrieve cell.")
            return
        }
        
        let updatedRep = cell.repTextField.text ?? ""
        let updatedSet = cell.setTextField.text ?? ""
        let updatedWeight = cell.weightTextField.text ?? ""
        let updatedDateText = cell.dateTextField.text ?? ""
        
        let selectedExercise = userExercises[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"
        guard let updatedDateComponents = dateFormatter.date(from: updatedDateText) else {
            print("Unable to parse date from text field")
            AlertHelper.shared.showAlert(from: self, title: "Error", message: "Invalid date format. Please use 'd MMM' format.")
            return
        }
        var currentDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: selectedExercise.date ?? Date())
        
        let updatedDayMonthComponents = Calendar.current.dateComponents([.day, .month], from: updatedDateComponents)
        currentDateComponents.day = updatedDayMonthComponents.day
        currentDateComponents.month = updatedDayMonthComponents.month
        
        guard let updatedDate = Calendar.current.date(from: currentDateComponents) else {
            print("Unable to create updated date")
            AlertHelper.shared.showAlert(from: self, title: "Error", message: "An error occurred while updating the date. Please try again.")
            return
        }
        var exerciseData: [String: Any] = [:]
        exerciseData["rep"] = updatedRep
        exerciseData["set"] = updatedSet
        exerciseData["weight"] = updatedWeight
        exerciseData["date"] = updatedDate
        
        
        
        userExerciseNetwork.updateUserExercise(exerciseID: selectedExercise.id ?? "", userExerciseData: exerciseData) { error in
            if let error = error {
                print("Error updating exercise: \(error.localizedDescription)")
                AlertHelper.shared.showAlert(from: self, title: "Error", message: "An error occurred while updating the exercise. Please try again later.")
            } else {
                self.showUserExercises()
                AlertHelper.shared.showAlert(from: self, title: "Success", message: "Exercise updated successfully!")
            }
        }
    }
        
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.userExercises.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! profileCell
            let userExercises = self.userExercises[indexPath.row]
            cell.exerciseNameLabel.text = userExercises.name
            cell.repTextField.text = userExercises.rep
            cell.setTextField.text = userExercises.set
            cell.weightTextField.text = userExercises.weight
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM"
            if let date = userExercises.date {
                let formattedDate = dateFormatter.string(from: date)
                cell.dateTextField.text = formattedDate
            } else {print("tarih bulunamadı")}
            return cell
            
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 199.0;//Choose your custom row height
        }
        
    }

