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
    
    
    //MARK:-Our Endponts Enums
    
    enum Endpoints {
        static let base = "https://www.themealdb.com/api/json/v1/1/"
        case categoriesList
        case areaList
        case filterbyArea(String)
        case filterbyCategory(String)
        case recipeLookUp(String)
        
        
        var stringValue: String {
            switch self {
            case .categoriesList: return Endpoints.base + SearchCriteria.categories.rawValue
            case .areaList: return Endpoints.base + SearchCriteria.area.rawValue
            case .filterbyArea(let area): return Endpoints.base + "filter.php?a=\(area))"
            case .filterbyCategory(let category): return Endpoints.base + "filter.php?c=\(category))"
            case .recipeLookUp(let recipeId): return Endpoints.base + "lookup.php?i=\(recipeId)"
                
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    //MARK:-Generic task for post Request
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
    
}
