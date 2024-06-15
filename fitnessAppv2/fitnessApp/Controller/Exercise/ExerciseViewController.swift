//
//  ExerciseViewController.swift
//  fitnessApp
//
//  Created by oguzhangumus on 18.05.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ExercisesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var exercisesTableView: UITableView!
    @IBOutlet weak var repTextField: UITextField!
    @IBOutlet weak var setTextField: UITextField!
    @IBOutlet weak var tabWarningLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    
    var exerciseNetwork = ExerciseNetwork()
    var exercises = [Exercise]()
    let db = Firestore.firestore()
    var network  = Network()

    var userEmail  = ""
    var userPassword = ""
    var selectedExerciseName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exercisesTableView.layer.borderWidth = 0.2
        exercisesTableView.layer.cornerRadius = 5
        exercisesTableView.delegate = self
        exercisesTableView.dataSource = self
        fetchExercises()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                   self.tabWarningLabel.isHidden = true
               }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchExercises()
    }
    func fetchExercises() {
        exerciseNetwork.fetchExercises { [weak self] exercises, error in
                if let error = error {
                    print("Error fetching exercises: \(error)")
                } else if let exercises = exercises {
                    self?.exercises = exercises
                    self?.exercisesTableView.reloadData()
                }
            }
        }
    
    @IBAction func addExerciseClicked(_ sender: Any) {
        if repTextField.text != "" && setTextField.text != "" {
            if selectedExerciseName != "" {
                if let currentUserID = Auth.auth().currentUser?.uid {
                    let exerciseDictionary = [
                        "weight": self.weightTextField.text!,
                        "name": self.selectedExerciseName,
                        "rep": self.repTextField.text!,
                        "set": self.setTextField.text!,
                        "date": Date(),
                        "userId": currentUserID
                    ] as [String : Any]
                    
                    let firestore = Firestore.firestore()
                    firestore.collection("userExercises").addDocument(data: exerciseDictionary) { error in
                        if error != nil {
                            AlertHelper.shared.showAlert(from: self, title: "Warning!", message: "Exercise could not be added!")
                        } else {
                            self.setTextField.text = ""
                            self.repTextField.text = ""
                            AlertHelper.shared.showAlert(from: self, title: "Success", message: "Exercise Added Successfully")
                        }
                    }
                }
            } else {
                AlertHelper.shared.showAlert(from: self, title: "Warning!", message: "Make sure that tap a exercise name!")
            }
        } else {
            AlertHelper.shared.showAlert(from: self, title: "Warning!", message: "Please fill in all fields!!")
        }
    }
    
    @IBAction func createExerciseClied(_ sender: Any) {
        performSegue(withIdentifier: "toCreateExerciseVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145.0;//Choose your custom row height
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ExerciseCell
        let exercise = exercises[indexPath.row]
        cell.exericeCellLabel.text = exercise.name
        cell.exerciseCellDescription.text = exercise.description
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedExercise = exercises[indexPath.row]
            selectedExerciseName = selectedExercise.name
    }
}

