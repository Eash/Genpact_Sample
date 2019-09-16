//
//  MealsListCell.swift
//  AppTest
//
//  Created by Ganesh Kumar on 14/09/19.
//  Copyright © 2019 Nextbrain. All rights reserved.
//

import UIKit

class MealsListCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var mealImg: UIImageView!
    @IBOutlet weak var mealNameLbl: UILabel!
    @IBOutlet weak var mealCategoryLbl: UILabel!
    @IBOutlet weak var mealAreaLbl: UILabel!
    
    let fontMedium = UIFont(name: FontName.medium.rawValue, size: 14)!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mealImg.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(_ data: MealsItemList){
        mealNameLbl.text = data.strMeal ?? ""
        
        let mealCategory = data.strCategory ?? ""
        let category = "Category: \(mealCategory)"
        let categoryAttrtxt = Constant.attributeColorString(category, colorString: mealCategory, defaultcolor: .gray, color: .black, font: fontMedium)
        mealCategoryLbl.attributedText = categoryAttrtxt
        
        let mealArea = data.strArea ?? ""
        let area = "Area: \(mealArea)"
        let areaAttrtxt = Constant.attributeColorString(area, colorString: mealArea, defaultcolor: .gray, color: .black, font: fontMedium)
        mealAreaLbl.attributedText = areaAttrtxt
        
        if let imgUrl = data.strMealThumb, imgUrl != "" {
            mealImg.load(url: URL(string: imgUrl)!)
        }
    }
    
}

