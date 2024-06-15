//
//  createFoodViewController.swift
//  fitnessApp
//
//  Created by oguzhangumus on 27.05.2024.
//

import UIKit

class createFoodViewController: UIViewController {

    @IBOutlet weak var foodName: UITextField!
    @IBOutlet weak var sugar: UITextField!
    @IBOutlet weak var carb: UITextField!
    @IBOutlet weak var fat: UITextField!
    @IBOutlet weak var protein: UITextField!
    @IBOutlet weak var calorie: UITextField!
    
    var foodNetwork = FoodNetwork()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

  
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addClicked(_ sender: Any) {
            guard let name = foodName.text, !name.isEmpty,
                  let sugar = sugar.text, !sugar.isEmpty,
                  let carb = carb.text, !carb.isEmpty,
                  let fat = fat.text, !fat.isEmpty,
                  let protein = protein.text, !protein.isEmpty,
                  let calorie = calorie.text, !calorie.isEmpty else {
                // Show an alert if any field is empty
                AlertHelper.shared.showAlert(from: self, title: "Error!", message: "All fields are required.")
                return
            }
            
            let food = Food(   name: name,
                            foodDescription: nil,
                            amount: nil,
                            calories:calorie,
                            protein:protein,
                            fat: fat,
                            carbohdrate: carb,
                            sugar: sugar)
            
            foodNetwork.addFood(food: food) { error in
                if let error = error {
                    print("Error adding food: \(error)")
                    AlertHelper.shared.showAlert(from: self, title: "Error!", message: "Failed to add food.")
                } else {
                    print("Food successfully added!")
                    AlertHelper.shared.showAlert(from: self, title: "Success!", message: "\(name) successfully added!")
                    self.foodName.text = ""
                    self.sugar.text = ""
                    self.carb.text = ""
                    self.fat.text = ""
                    self.protein.text = ""
                    self.calorie.text = ""
                        //self.dismiss(animated: true, completion: nil)
                }
            }
        }
}



