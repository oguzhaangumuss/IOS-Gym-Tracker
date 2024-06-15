//
//  myMealViewController.swift
//  fitnessApp
//
//  Created by oguzhangumus on 29.05.2024.
//

import UIKit
import FirebaseAuth

class MyMealViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var meals = [Meal]()
    var mealNetwork = MealNetwork()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableView konfigürasyonu
        tableView.dataSource = self
        tableView.delegate = self
        
        // Kullanıcının yemeklerini getir
        fetchUserMeals()
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchUserMeals()
    }
    
    // Kullanıcının yemeklerini getirme işlemi
    func fetchUserMeals() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Error: User not authenticated.")
            return
        }
        
        mealNetwork.fetchMeals(forUser: userID) { [weak self] meals, error in
            if let error = error {
                print("Error fetching meals: \(error)")
            } else if let meals = meals {
                // Yemekleri güncelle
                self?.meals = meals
                // TableView'i yenile
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBAction func deleteClicked(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        let mealIndex = button.tag / 100 // Meal index'i
        let foodIndex = button.tag % 100 // Food index'i
        
        guard mealIndex < meals.count else {
            print("Invalid meal index")
            AlertHelper.shared.showAlert(from: self, title: "Error!", message: "Invalid meal index")
            return
        }
        
        if let foods = meals[mealIndex].foods {
            guard foodIndex < foods.count else {
                print("Invalid food index")
                AlertHelper.shared.showAlert(from: self, title: "Error!", message: "Invalid food index")
                return
            }
            
            guard let mealID = meals[mealIndex].id, let foodID = foods[foodIndex].id else {
                print("Meal ID or Food ID is nil")
                return
            }
            
            mealNetwork.deleteFoodFromMeal(mealID: mealID, foodID: foodID) { [weak self] error in
                if let error = error {
                    print("Error deleting food from meal: \(error)")
                    // Silme işlemi başarısız olursa kullanıcıya bildirim gösterebilirsiniz.
                    AlertHelper.shared.showAlert(from: self!, title: "Error!", message: "An error occurred while deleting the food!")
                } else {
                    self?.meals[mealIndex].foods?.remove(at: foodIndex)
                    self?.tableView.reloadData()
                }
            }
        } else {
            print("Foods list is nil")
            AlertHelper.shared.showAlert(from: self, title: "Error!", message: "Foods list is nil")
        }
    }


    
    
    @IBAction func updateClicked(_ sender: Any) {
        
    }
    
    // TableViewDataSource Metodları
    func numberOfSections(in tableView: UITableView) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals[section].foods!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodCell
        
        let meal = meals[indexPath.section]
        let food = meal.foods?[indexPath.row]
        
        
        cell.foodNameLabel.text = food!.name
        cell.calLabel.text = food!.calories
        cell.carbLabel.text = food!.carbohdrate
        cell.fatLabel.text = food!.fat
        cell.sugarLabel.text = food!.sugar
        cell.proteinLabel.text = food!.protein
        
        return cell
    }
    
    // TableViewDelegate Metodları
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return meals[section].mealName
    }
}

