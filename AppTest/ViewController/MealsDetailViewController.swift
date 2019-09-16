//
//  MealsDetailViewController.swift
//  AppTest
//
//  Created by Ganesh Kumar on 15/09/19.
//  Copyright © 2019 Nextbrain. All rights reserved.
//

import UIKit

class MealsDetailViewController: UIViewController {
    
    @IBOutlet weak var receipeImg: UIImageView!
    @IBOutlet weak var mealNameLbl: UILabel!
    @IBOutlet weak var receipeInstructionLbl: UILabel!
    @IBOutlet weak var favouriteBtn: UIButton!
    
    var mealItem: MealsItemList?
    var receipeItem: ReceipeItem?
    var isFromFavourite = false
    let persistanceManager = PersistenceManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadingUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationSetup()
    }

    func navigationSetup(){
        self.title = "Receipe Details"
        self.navigationItem.hidesBackButton = true
        
        let backArrow = UIImage(named: "backArrow")?.withRenderingMode(.alwaysOriginal)
        let backBtn = UIBarButtonItem(image: backArrow, style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.leftBarButtonItem = backBtn
        
    }
    
    
    //MARK: - Button Action
    @IBAction func backAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favouriteAction(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            storingFavouriteItems()
        }
        else{
            removefavouriteItem()
        }
    }

}

//MARK: - Loading UI
extension MealsDetailViewController{
    func loadingUI(){
        mealNameLbl.text = mealItem?.strMeal ?? receipeItem?.mealName
        
        receipeInstructionLbl.text = mealItem?.strInstructions ?? receipeItem?.mealInstruction
        
        if let imgUrl = mealItem?.strMealThumb, imgUrl != ""{
            receipeImg.load(url: URL(string: imgUrl)!)
        }
        
        if let img = receipeItem?.mealsImage, img != ""{
            receipeImg.load(url: URL(string: img)!)
        }
        
        checkingFavourites()
    }
    
    func checkingFavourites(){
        let id = isFromFavourite ? receipeItem?.mealId : mealItem?.idMeal
        let mealId = fetchingFavourites(id ?? "0")
        if mealId == id{favouriteBtn.isSelected = true}
        else{favouriteBtn.isSelected = false}
    }
}


//MARK: - CoreData Stack
extension MealsDetailViewController{
    func storingFavouriteItems(){
        let context = persistanceManager.context
        let receipe = ReceipeItem(context: context)
        receipe.mealId = mealItem?.idMeal ?? ""
        receipe.mealArea = mealItem?.strArea ?? ""
        receipe.mealName = mealItem?.strMeal ?? ""
        receipe.mealCategory = mealItem?.strCategory ?? ""
        receipe.mealsImage = mealItem?.strMealThumb ?? ""
        receipe.mealInstruction = mealItem?.strInstructions ?? ""
        persistanceManager.save()
    }
    
    func fetchAllFavourites() -> [ReceipeItem]{
        let meals = persistanceManager.fetch(ReceipeItem.self)
        return meals
    }
    
    func fetchingFavourites(_ id: String) -> String{
        if fetchAllFavourites().count > 0 {
            let meals = persistanceManager.fetch(ReceipeItem.self, mealId: id)
            if meals.count > 0 {return meals[0].mealId ?? "0"}
        }
        return "0"
    }
    
    func removefavouriteItem(){
        if let id = isFromFavourite ? receipeItem?.mealId : mealItem?.idMeal{
            persistanceManager.delete(ReceipeItem.self, mealId: id)}
        persistanceManager.save()
    }
}
