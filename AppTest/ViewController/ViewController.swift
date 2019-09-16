//
//  ViewController.swift
//  AppTest
//
//  Created by Ganesh Kumar on 03/09/19.
//  Copyright © 2019 Nextbrain. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController {
    
    @IBOutlet weak var mealsTblVw: UITableView!
    @IBOutlet weak var errorLbl: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var displayLoading: Bool = false{
        didSet{
            DispatchQueue.main.async {
                if self.displayLoading{
                    self.activityIndicator.startAnimating()
                }
                else{
                    self.activityIndicator.stopAnimating()
                }
                self.activityIndicator.isHidden = !self.displayLoading
            }
        }
    }
    
    var mealsList: [MealsItemList]?
    let persistanceManager = PersistenceManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        MealsListCell.registerWithTable(mealsTblVw)
        getMealList()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        errorLbl.isHidden = true
        navigationSetup()
    }
    
    func navigationSetup(){
        self.title = "Receipe"

        self.navigationController?.navigationBar.barTintColor = Constant.hextoRGB("008b77")
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        let favImg = UIImage(named: "navFavourite")?.withRenderingMode(.alwaysOriginal)
        let rightbaritem = UIBarButtonItem(image: favImg, style: .plain, target: self, action: #selector(getFavouriteList))
        self.navigationItem.rightBarButtonItem = nil
        if fetchAllFavourites().count > 0{
            self.navigationItem.rightBarButtonItem = rightbaritem
        }
    }
    
    func loadingMealsList(){
        DispatchQueue.main.async {
            if let meals = self.mealsList, meals.count > 0 {
                self.mealsTblVw.reloadData()
            }
            else{
                self.mealsTblVw.isHidden = true
                self.errorLbl.isHidden = false
                self.errorLbl.text = "No data found"
            }
        }
    }
    
    
    //MARK: - BUTTON ACTION
    @IBAction func getFavouriteList(){
        let task = FavouriteListViewController.instantiate(fromAppStoryboard: .main)
        self.navigationController?.pushViewController(task, animated: true)
    }
}

//MARK: API CALL
extension ViewController{
    func getMealList(){
        displayLoading = true
        let getMealUrl = "https://www.themealdb.com/api/json/v1/1/latest.php"
        RequestManager().getCodableResponse(getMealUrl, method: .GET, param: [:]) { (data, status) in
            self.displayLoading = false
            let result = try? JSONDecoder().decode(response.self,from: data)
            if status{
                self.mealsList = result?.meals
            }
            self.loadingMealsList()
        }
    }
}


//MARK: - UITableView DataSource
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let meals = mealsList, meals.count > 0{return meals.count}
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(MealsListCell.self)
        cell.selectionStyle = .none
        
        if let meals = mealsList?[indexPath.row]{
            cell.setupCell(meals)
        }
        
        return cell
    }
}

//MARK: - UITableView Delegate
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = mealsList?[indexPath.row]
        
        let task = MealsDetailViewController.instantiate(fromAppStoryboard: .main)
        task.mealItem = data
        self.navigationController?.pushViewController(task, animated: true)
    }
}


//MARK: - CoreData Stack
extension ViewController{
    func fetchAllFavourites() -> [ReceipeItem]{
        let meals = persistanceManager.fetch(ReceipeItem.self)
        return meals
    }
}
