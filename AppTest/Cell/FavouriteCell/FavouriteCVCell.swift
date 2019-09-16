//
//  FavouriteCVCell.swift
//  AppTest
//
//  Created by Ganesh Kumar on 15/09/19.
//  Copyright © 2019 Nextbrain. All rights reserved.
//

import UIKit

protocol FavouriteListDelegate: AnyObject {
    func unfavouriteAction(_ tag: Int)
}

class FavouriteCVCell: UICollectionViewCell, ReusableView {
    
    @IBOutlet weak var mealImg: UIImageView!
    @IBOutlet weak var mealNameLbl: UILabel!
    @IBOutlet weak var favouriteBtn: UIButton!
    
    weak var delegate: FavouriteListDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func unfavouriteClickAction(_ sender: UIButton){
        delegate.unfavouriteAction(sender.tag)
    }
    
    
    func setupUI(_ data: ReceipeItem){
        mealNameLbl.text = data.mealName ?? ""
        
        if let imgURL = data.mealsImage, imgURL != ""{
            mealImg.load(url: URL(string: imgURL)!)
        }
    }
}
