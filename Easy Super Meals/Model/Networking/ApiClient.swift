//
//  ApiClient.swift
//  Easy Super Meals
//
//  Created by James Mbugua on 21/02/2021.
//

import Foundation


//MARK:-Api Client
class ApiClient {
    
    
    
    enum SearchCriteria : String {
        case categories = "list.php?c=list"
        case area = "list.php?a=list"
    }
    
    
    //MARK:- Our Endponts Enums
    
    enum Endpoints {
        static let base = "https://www.themealdb.com/api/json/v1/1/"
        case categoriesList
        case areaList
        case filterbyArea(String)
        case filterbyCategory(String)
        case recipeLookUp(String)
        case thumbImage(String)
        case bannerImage(String)
        
        
        var stringValue: String {
            switch self {
            case .categoriesList: return Endpoints.base + SearchCriteria.categories.rawValue
            case .areaList: return Endpoints.base + SearchCriteria.area.rawValue
            case .filterbyArea(let area): return Endpoints.base + "filter.php?a=\(area)"
            case .filterbyCategory(let category): return Endpoints.base + "filter.php?c=\(category)"
            case .recipeLookUp(let recipeId): return Endpoints.base + "lookup.php?i=\(recipeId)"
            case .thumbImage(let url): return url + "/preview"
            case .bannerImage(let url): return url
                
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    //MARK:- Generic task for post Request
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType:ResponseType.Type, completion: @escaping(ResponseType?, Error?)-> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(response, nil)
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                
                
            }
        }
        task.resume()
    }
    
    
    //MARK:- Get Categories List
    class func requestCategoriesList(completionHandler: @escaping ([String], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.categoriesList.url, responseType: CategoriesList.self) { (response, error) in
            if let response = response {
                let catList = response.category.map({$0})
                var stringlist: [String] = []
                for category in catList {
                    print("\(category.name)")
                    stringlist.append(category.name)
                }
                completionHandler(stringlist, nil)
                
            }else {
                completionHandler([], error)
            }
        }
    }
    
    //MARK:- Get Location Area List
    class func requestAreaList(completionHandler: @escaping ([String], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.areaList.url, responseType: AreaList.self) { (response, error) in
            if let response = response {
                let catList = response.area.map({$0})
                var stringlist: [String] = []
                for category in catList {
                    print("\(category.name)")
                    stringlist.append(category.name)
                }
                completionHandler(stringlist, nil)
                
            }else {
                completionHandler([], error)
            }
        }
    }
    
    
    //MARK:- Get Short Recipe List
    /*
     Here we get the short recipe list base on the URL, either by List or by Category or Location area
     */
    class func requestRecipeList(url:URL, completionHandler: @escaping ([ShortRecipe], Error?) -> Void) {
        taskForGETRequest(url: url, responseType: RecipeListResponse.self) { (response, error) in
            if let response = response {
                completionHandler(response.list, nil)
            }else {
                completionHandler([], error)
            }
        }
    }
    
    
    //MARK:- Download Recipe Thumb image
    /*
     For the table view we use thumb images to save data
     */
    class func downloadThumbImage(path: String, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.thumbImage(path).url) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        task.resume()
    }
    
    //MARK:- Download full Recipe Banner
    /*
     download the full image Banner
     */
    class func downloadBannerImage(imageUrl: String, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.bannerImage(imageUrl).url) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        task.resume()
    }
    
    
    
    //MARK:-Full Recipe Sample Response
    /*
     "meals": [
             {
                 "idMeal": "52968",
                 "strMeal": "Mbuzi Choma (Roasted Goat)",
                 "strDrinkAlternate": null,
                 "strCategory": "Goat",
                 "strArea": "Kenyan",
                 "strInstructions": "1. Steps for the Meat: \r\n Roast meat over medium heat for 50 minutes and salt it as you turn it.\r\n\r\n2. Steps for Ugali:\r\nBring the water and salt to a boil in a heavy-bottomed saucepan. Stir in the cornmeal slowly, letting it fall through the fingers of your hand.\r\n\r\n3. Reduce heat to medium-low and continue stirring regularly, smashing any lumps with a spoon, until the mush pulls away from the sides of the pot and becomes very thick, about 10 minutes.\r\n\r\n4.Remove from heat and allow to cool.\r\n\r\n5. Place the ugali into a large serving bowl. Wet your hands with water, form a ball and serve.\r\n\r\n6. Steps for Kachumbari: Mix the tomatoes, onions, chili and coriander leaves in a bowl.\r\n\r\n7. Serve and enjoy!\r\n\r\n",
                 "strMealThumb": "https://www.themealdb.com/images/media/meals/cuio7s1555492979.jpg",
                 "strTags": "BBQ,Meat",
                 "strYoutube": "",
                 "strIngredient1": "Goat Meat",
                 "strIngredient2": "Corn Flour",
                 "strIngredient3": "Tomatoes",
                 "strIngredient4": "Salt",
                 "strIngredient5": "Onion",
                 "strIngredient6": "Green Chilli",
                 "strIngredient7": "Coriander Leaves",
                 "strIngredient8": "",
                 "strIngredient9": "",
                 "strIngredient10": "",
                 "strIngredient11": "",
                 "strIngredient12": "",
                 "strIngredient13": "",
                 "strIngredient14": "",
                 "strIngredient15": "",
                 "strIngredient16": "",
                 "strIngredient17": "",
                 "strIngredient18": "",
                 "strIngredient19": "",
                 "strIngredient20": "",
                 "strMeasure1": "1 kg",
                 "strMeasure2": "1 kg",
                 "strMeasure3": "2",
                 "strMeasure4": "Pinch",
                 "strMeasure5": "1",
                 "strMeasure6": "1",
                 "strMeasure7": "1  bunch",
                 "strMeasure8": " ",
                 "strMeasure9": " ",
                 "strMeasure10": " ",
                 "strMeasure11": " ",
                 "strMeasure12": " ",
                 "strMeasure13": " ",
                 "strMeasure14": " ",
                 "strMeasure15": " ",
                 "strMeasure16": " ",
                 "strMeasure17": " ",
                 "strMeasure18": " ",
                 "strMeasure19": " ",
                 "strMeasure20": " ",
                 "strSource": "",
                 "dateModified": null
             }
         ]
     */
    //MARK:-Get Full Recipe
    /*
     The Full recipe response is a bit messy, for instance the Ingredients (strIngredient1) and their quantity (strMeasure6) are not
     in an array, therefore I had to make a trade off to  use JSONSerialization instead of Codable protocal.
     as a result I converted recipe Ingredients to a proper array
     */
    class func requestFullRecipe(recipeId: String, completion: @escaping (RestRecipe?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.recipeLookUp(recipeId).url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String:Any],
               let meals = json["meals"] as? [[String:Any]], // the response comes as an Array
               let strMeal = meals[0]["strMeal"] as? String, meals.count > 0 {  //make sure the "meals array" is greater than zero and use the first Item
                //here we extract the Recipe Details which could be empty string "" or null, so we set an empty string as default
                let idMeal = (meals[0]["idMeal"] as? String) ??  ""
                let strCategory = meals[0]["strCategory"] as? String ??  ""
                let strArea = meals[0]["strArea"] as? String ??  ""
                let strInstructions = meals[0]["strInstructions"] as? String ??  ""
                let strMealThumb = meals[0]["strMealThumb"] as? String ??  ""
                let strTags = meals[0]["strTags"] as? String ??  ""
                let strYoutube = meals[0]["strYoutube"] as? String ?? ""
                let strSource = meals[0]["strSource"] as? String ??  ""
               
                /*
                 Here we want we convert the recipe Ingredients to a proper array
                 From the response we know strIngredient range from 0...20 hence we use a for loop.
                 loop through and put Ingredients and its respective measure (quantity) in a RecipeIngredients array
                 */
                var ingredients : [RecipeIngredients] = []
                for n in 1...20 {
                    let strIngredient = meals[0]["strIngredient\(n)"] as? String ?? ""
                    if strIngredient != "" {
                        let strMeasure = meals[0]["strMeasure\(n)"] as? String ?? ""
                        let recipeIngredients = RecipeIngredients(name: strIngredient, quantity: strMeasure)
                        ingredients.append(recipeIngredients)
                    }
                    
                }
                /*
                 Finally we have a well formatted Recipe Data
                 we put it in a RestRecipe struct
                 */
                let recipe = RestRecipe(name: strMeal , id: idMeal, category: strCategory, area: strArea, instructions: strInstructions, tags: strTags, imageUrl: strMealThumb, youtubeLink: strYoutube, source: strSource, ingredients: ingredients)
                DispatchQueue.main.async {
                    completion(recipe, nil)
                }
            }
            
        }
        task.resume()
    }
}
