//
//  createMealViewController.swift
//  fitnessApp
//
//  Created by oguzhangumus on 28.05.2024.
//

import UIKit
import FirebaseAuth

class createMealViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var mealNameTextField: UITextField!
    @IBOutlet weak var createMealPicker: UIPickerView!
    
    var meal = [Meal]()
    var food = [Food]()
    
    var foodnetwork = FoodNetwork()
    var mealNetwork = MealNetwork()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createMealPicker.delegate = self
        createMealPicker.dataSource = self
        
    }
    
    func showFoods() {
        foodnetwork.fetchFoods { [weak self] foods, error in
            if let error = error {
                print("Error fetching foods: \(error)")
            } else if let foods = foods {
                self?.food = foods
                self?.createMealPicker.reloadAllComponents()
            }
        }
    }
    
    
    @IBAction func createMealBtnClicked(_ sender: Any) {
        guard let mealName = mealNameTextField.text, !mealName.isEmpty else {
            AlertHelper.shared.showAlert(from: self, title: "Error", message: "Please enter a meal name.")
            return
        }
        
        let selectedFoodIndex = createMealPicker.selectedRow(inComponent: 0)
        let selectedFood = food[selectedFoodIndex]
        
        let newMeal = Meal(userId: Auth.auth().currentUser?.uid ?? "",
                           foods: [selectedFood],
                           mealName: mealName)
        
        mealNetwork.addMeal(meal: newMeal) { [weak self] error in
            if error != nil {
                AlertHelper.shared.showAlert(from: self!, title: "Error", message: "Failed to add meal.")
            } else {
                AlertHelper.shared.showAlert(from: self!, title: "Success", message: "\(mealName) added successfully!")
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Picker Funcs
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return food.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return food[row].name
    }
    
}
