//
//  FoodViewController.swift
//  fitnessApp
//
//  Created by oguzhangumus on 27.05.2024.
//

import UIKit
import FirebaseAuth

class FoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var foodTableView: UITableView!
    @IBOutlet weak var foodPicker: UIPickerView!
    @IBOutlet weak var createMealTextField: UITextField!
    @IBOutlet weak var `switch`: UISwitch!
    
    var food = [Food]()
    var meal = [Meal]()
    var mealNames = ["Select"]
    
    var foodnetwork = FoodNetwork()
    var mealNetwork = MealNetwork()
    
    var selectedFoodName = ""
    var selectedMealName = ""
    var selectedMealId = ""
    var createMealText = ""
    var selectedFoodId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodTableView.dataSource = self
        foodTableView.delegate = self
        foodPicker.delegate = self
        foodPicker.dataSource = self
        
        `switch`.isOn = false // Switch varsayılan olarak kapalı
        createMealTextField.isUserInteractionEnabled = false // TextField varsayılan olarak devre dışı
        
        `switch`.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)

        showFoods()
        showMeals()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showFoods()
        showMeals()
    }
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        createMealTextField.isUserInteractionEnabled = sender.isOn
        if !sender.isOn {
            createMealTextField.text = "" // Switch kapalıysa TextField'ı temizle
            foodPicker.selectRow(0, inComponent: 0, animated: true) // "Select" seçeneğini seç
        }
    }
    
    func showFoods() {
        foodnetwork.fetchFoods { [weak self] foods, error in
            if let error = error {
                print("Error fetching exercises: \(error)")
            } else if let foods = foods {
                self?.food = foods
                self?.foodTableView.reloadData()
            }
        }
    }
    
    func showMeals() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Error: User not authenticated.")
            return
        }
        
        mealNetwork.fetchMeals(forUser: userID) { [weak self] meals, error in
            if let error = error {
                print("Error fetching meals: \(error)")
            } else if let meals = meals {
                var mealNames: [String] = ["Select"]
                for meal in meals {
                    if let mealName = meal.mealName {
                        mealNames.append(mealName)
                    }
                }
                self?.meal = meals
                self?.mealNames = mealNames
                self?.foodPicker.reloadAllComponents() // Picker'ı güncelle
            }
        }
    }

    
    @IBAction func addFoodToMeal(_ sender: Any){
        var mealName = ""
        if `switch`.isOn {
            guard let enteredMealName = createMealTextField.text, !enteredMealName.isEmpty else {
                AlertHelper.shared.showAlert(from: self, title: "Error", message: "Please enter a meal name.")
                return
            }
            mealName = enteredMealName
        } else {
            guard !selectedMealName.isEmpty && selectedMealName != "Select" else {
                AlertHelper.shared.showAlert(from: self, title: "Error", message: "Please select a meal.")
                return
            }
            mealName = selectedMealName
        }

        guard let selectedFood = food.first(where: { $0.id == selectedFoodId }) else {
            print("Selected food not found.")
            return
        }

        let userId = Auth.auth().currentUser?.uid ?? ""

        if let existingMeal = meal.first(where: { $0.userId == userId && $0.mealName == mealName }) {
            // Eğer böyle bir öğün varsa, yeni yiyeceği ekle
            if existingMeal.foods!.contains(where: { $0.id == selectedFoodId }) {
                AlertHelper.shared.showAlert(from: self, title: "Error", message: "\(selectedFood.name!) already exists in \(existingMeal.mealName ?? "the meal").")
                createMealTextField.text = ""
                return
            }

            var updatedFoods = existingMeal.foods ?? []
            updatedFoods.append(selectedFood)

            let updatedMealData: [String: Any] = [
                "userId": userId,
                "foods": updatedFoods.map { ["id": $0.id, "name": $0.name, "calories": $0.calories, "carbohdrate": $0.carbohdrate, "fat": $0.fat, "sugar": $0.sugar, "protein": $0.protein] },
                "mealName": mealName
            ]

            mealNetwork.updateMeal(mealID: existingMeal.id ?? "", mealData: updatedMealData) { [weak self] error in
                if let error = error {
                    print("Error updating meal: \(error)")
                    AlertHelper.shared.showAlert(from: self!, title: "Error", message: "Failed to update meal.")
                } else {
                    AlertHelper.shared.showAlert(from: self!, title: "Success", message: "\(selectedFood.name!) added to \(existingMeal.mealName!) successfully!")
                    self?.showMeals()
                }
            }
        } else {
            // Belirtilen mealName ve userID ile eşleşen bir öğün yoksa yeni bir öğün oluşturulur
            let newMeal = Meal(userId: userId, foods: [selectedFood], mealName: mealName)

            mealNetwork.addMeal(meal: newMeal) { [weak self] error in
                self?.createMealTextField.text = ""
                if let error = error {
                    print("Error adding meal: \(error)")
                    AlertHelper.shared.showAlert(from: self!, title: "Error", message: "Failed to add meal.")
                } else {
                    AlertHelper.shared.showAlert(from: self!, title: "Success", message: "\(selectedFood.name!) added to \(newMeal.mealName!) successfully!")
                    self?.showMeals()
                }
            }
        }
    }

    /*{
        var mealName = ""
        if `switch`.isOn {
            guard let enteredMealName = createMealTextField.text, !enteredMealName.isEmpty else {
                AlertHelper.shared.showAlert(from: self, title: "Error", message: "Please enter a meal name.")
                return
            }
            mealName = enteredMealName
        } else {
            guard !selectedMealName.isEmpty && selectedMealName != "Select" else {
                AlertHelper.shared.showAlert(from: self, title: "Error", message: "Please select a meal.")
                return
            }
            mealName = selectedMealName
        }

        guard let selectedFood = food.first(where: { $0.id == selectedFoodId }) else {
            print("Selected food not found.")
            return
        }

        let userId = Auth.auth().currentUser?.uid ?? ""

        if let existingMeal = meal.first(where: { $0.userId == userId && $0.mealName == mealName }) {
            // Eğer böyle bir öğün varsa, yeni yiyeceği ekle
            if existingMeal.foods.contains(where: { $0.id == selectedFoodId }) {
                AlertHelper.shared.showAlert(from: self, title: "Error", message: "\(selectedFood.name!) already exists in \(existingMeal.mealName ?? "the meal").")
                createMealTextField.text = ""
                return
            }

            var updatedFoods = existingMeal.foods
            updatedFoods.append(selectedFood)

            let updatedMealData: [String: Any] = [
                "userId": userId,
                "foods": updatedFoods.map { ["id": $0.id, "name": $0.name, "calories": $0.calories, "carbohdrate": $0.carbohdrate, "fat": $0.fat, "sugar": $0.sugar, "protein": $0.protein] },
                "mealName": mealName
            ]

            mealNetwork.updateMeal(mealID: existingMeal.id ?? "", mealData: updatedMealData) { [weak self] error in
                if let error = error {
                    print("Error updating meal: \(error)")
                    AlertHelper.shared.showAlert(from: self!, title: "Error", message: "Failed to update meal.")
                } else {
                    AlertHelper.shared.showAlert(from: self!, title: "Success", message: "\(selectedFood.name!) added to \(existingMeal.mealName!) successfully!")
                    self?.showMeals()
                }
            }
        } else {
            // there is no match with mealName and UserID
            let newMeal = Meal(userId: userId, foods: [selectedFood], mealName: mealName)

            mealNetwork.addMeal(meal: newMeal) { [weak self] error in
                self?.createMealTextField.text = ""
                if let error = error {
                    print("Error adding meal: \(error)")
                    AlertHelper.shared.showAlert(from: self!, title: "Error", message: "Failed to add meal.")
                } else {
                    AlertHelper.shared.showAlert(from: self!, title: "Success", message: "\(selectedFood.name!) added to \(newMeal.mealName!) successfully!")
                    self?.showMeals()
                }
            }
        }
    }
    */
    @IBAction func createMealClicked(_ sender: Any) {
        performSegue(withIdentifier: "toCreateMealVC", sender: nil)
    }
    
    @IBAction func createFoodClicked(_ sender: Any) {
        performSegue(withIdentifier: "toCreateFoodVC", sender: nil)
    }

    // Table Funcs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return food.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodCell
        let food = food[indexPath.row]
        cell.calLabel.text = food.calories
        cell.carbLabel.text = food.carbohdrate
        cell.fatLabel.text = food.fat
        cell.foodNameLabel.text = food.name
        cell.sugarLabel.text = food.sugar
        cell.proteinLabel.text = food.protein
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175.0 // Choose your custom row height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFood = food[indexPath.row]
        selectedFoodName = selectedFood.name!
        selectedFoodId = selectedFood.id!
    }

    // Picker Funcs
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mealNames.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mealNames[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedMealName = mealNames[row]
    }
}
