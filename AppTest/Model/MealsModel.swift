//
//  MealsModel.swift
//  AppTest
//
//  Created by Ganesh Kumar on 14/09/19.
//  Copyright © 2019 Nextbrain. All rights reserved.
//

import Foundation


struct response: Codable {
    var meals: [MealsItemList]?
}

struct MealsItemList: Codable{
    var idMeal: String?
    var strMeal: String?
    var strCategory: String?
    var strArea: String?
    var strInstructions: String?
    var strMealThumb: String?
}


