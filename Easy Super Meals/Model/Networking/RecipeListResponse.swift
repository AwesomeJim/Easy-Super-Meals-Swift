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

struct RestRecipe:Codable {
    let name:String
    let id:String
    let category:String
    let area:String
    let instructions:String
    let tags:String
    let imageUrl:String
    let youtubeLink:String
    let source:String
    let ingredients:[RecipeIngredients]
}


struct RecipeIngredients:Codable {
    let name:String
    let quantity:String
}



struct recipeRawResponse:Codable {
    let idMeal:String
    let     strMeal:String
    let        strDrinkAlternate:String
    let        strCategory:String
    let        strArea:String
    let        strInstructions:String
    let        strMealThumb:String
    let        strTags:String
    let        strYoutube:String
    let      strIngredient1:String
    let        strIngredient2:String
    let        strIngredient3:String
    let        strIngredient4:String
    let        strIngredient5:String
    let        strIngredient6:String
    let        strIngredient7:String
    let        strIngredient8:String
    let        strIngredient9:String
    let        strIngredient10:String
    let        strIngredient11:String
    let        strIngredient12:String
    let        strIngredient13:String
    let        strIngredient14:String
    let        strIngredient15:String
    let        strIngredient16:String
    let      strIngredient17:String
    let        strIngredient18:String
    let        strIngredient19:String
    let        strIngredient20:String
    let        strMeasure1:String
    let        strMeasure2:String
    let        strMeasure3:String
    let        strMeasure4:String
    let        strMeasure5:String
    let        strMeasure6:String
    let        strMeasure7:String
    let        strMeasure8:String
    let        strMeasure9:String
    let        strMeasure10:String
    let        strMeasure11:String
    let        strMeasure12:String
    let        strMeasure13:String
    let        strMeasure14:String
    let        strMeasure15:String
    let        strMeasure16:String
    let        strMeasure17:String
    let        strMeasure18:String
    let        strMeasure19:String
    let        strMeasure20:String
    let        strSource:String
    let        dateModified:String
    
}
