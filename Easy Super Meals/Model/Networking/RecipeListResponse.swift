//
//  RecipeListResponse.swift
//  Easy Super Meals
//
//  Created by James Mbugua on 21/02/2021.
//

import Foundation

//MARK:-RecipeListResponse
struct RecipeListResponse :Codable {
    let list : [ShortRecipe]
    
    enum CodingKeys: String, CodingKey {
        case list = "meals"
    }
}

//MARK:- Recipe List
struct ShortRecipe:Codable {
    let name : String
    let imageurl : String
    let id : String
    enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case imageurl = "strMealThumb"
        case id = "idMeal"
    }
    
}
