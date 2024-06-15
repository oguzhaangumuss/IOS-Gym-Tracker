//
//  ExerciseCell.swift
//  fitnessApp
//
//  Created by oguzhangumus on 19.05.2024.
//

import UIKit

class ExerciseCell: UITableViewCell {

    @IBOutlet weak var exerciseCellDescription: UITextView!
    @IBOutlet weak var exericeCellLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textViewEditable(isEditable: Bool) {
           exerciseCellDescription.isEditable = isEditable
       }

}
