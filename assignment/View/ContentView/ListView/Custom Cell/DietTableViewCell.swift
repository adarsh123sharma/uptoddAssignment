//
//  DietTableViewCell.swift
//  assignment
//
//  Created by Adarsh Sharma on 25/12/24.
//

import UIKit

class DietTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: DietTableViewCell.self)
    
    @IBOutlet weak var TimeLbl: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var btnCustomise: UIButton!
    @IBOutlet weak var btnFed: UIButton!
    @IBOutlet weak var lblTimeMins: UILabel!
    @IBOutlet weak var lblRecipeName: UILabel!
    @IBOutlet weak var imgRecipe: UIImageView!
    
    func configure(with recipe: Recipes) {
        TimeLbl.text = recipe.timeSlot ?? "N/A"
        lblTimeMins.text = "\(recipe.duration ?? 0) mins"
        lblRecipeName.text = recipe.title
//        imgRecipe.loadPreviewImage(withOptions: .previewImage, completionHandler: nil)
    }
}
