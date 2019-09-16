//
//  FavouriteListViewController.swift
//  AppTest
//
//  Created by Ganesh Kumar on 15/09/19.
//  Copyright © 2019 Nextbrain. All rights reserved.
//

import UIKit

class FavouriteListViewController: UIViewController {
    
    @IBOutlet weak var favouriteCV: UICollectionView!
    @IBOutlet weak var errorLbl: UILabel!
    
    let persistanceManager = PersistenceManager.shared
    
    var favouriteItems: [ReceipeItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        FavouriteCVCell.registerWithCollectionView(favouriteCV)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationSetup()
        getFavouriteList()
    }
    
    func navigationSetup(){
        self.title = "Favourite List"
        self.navigationItem.hidesBackButton = true
        
        let backArrow = UIImage(named: "backArrow")?.withRenderingMode(.alwaysOriginal)
        let backBtn = UIBarButtonItem(image: backArrow, style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.leftBarButtonItem = backBtn
    }
    
    //Getting all Favourite List
    func getFavouriteList(){
        favouriteItems = []
        if fetchAllFavourites().count > 0{
            favouriteItems = fetchAllFavourites()
        }
        
        if let data = favouriteItems, data.count > 0 {
            favouriteCV.isHidden = false
            errorLbl.isHidden = true
        }
        else{
            favouriteCV.isHidden = true
            errorLbl.isHidden = false
            errorLbl.text = "No favourite items"
        }        
        DispatchQueue.main.async {self.favouriteCV.reloadData()}
    }
    
    //MARK: - Button Action
    @IBAction func backAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - UICollectionView Datasource
extension FavouriteListViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let favourite = favouriteItems, favourite.count > 0{
            return favourite.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FavouriteCVCell = collectionView.dequeueReusable(for: indexPath)
        cell.favouriteBtn.tag = indexPath.row
        cell.delegate = self
        if let data = favouriteItems?[indexPath.row]{
            cell.setupUI(data)
        }
        
        return cell
    }
    
    
}

//MARK: - UICollectionView Delegate
extension FavouriteListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.size.width / 2) - 4
        return CGSize(width: width, height: 225)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = favouriteItems![indexPath.row]
        
        let task = MealsDetailViewController.instantiate(fromAppStoryboard: .main)
        task.isFromFavourite = true
        task.receipeItem = data
        self.navigationController?.pushViewController(task, animated: true)
    }
}

//MARK: - Custom Delegate
extension FavouriteListViewController: FavouriteListDelegate{
    func unfavouriteAction(_ tag: Int) {
        if let mealid = favouriteItems?[tag].mealId{
            removeFavourites(mealid)
        }
        getFavouriteList()
    }
}


//MARK: - CoreData Stack
extension FavouriteListViewController{
    func fetchAllFavourites() -> [ReceipeItem]{
        let meals = persistanceManager.fetch(ReceipeItem.self)
        return meals
    }
    
    func removeFavourites(_ id: String){
        persistanceManager.delete(ReceipeItem.self, mealId: id)
        persistanceManager.save()
    }
}
