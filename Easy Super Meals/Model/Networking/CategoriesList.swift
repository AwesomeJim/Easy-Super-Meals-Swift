//
//  CategoriesList.swift
//  Easy Super Meals
//
//  Created by James Mbugua on 21/02/2021.
//

import Foundation


struct CategoriesList :Codable {
    let category : [Category]
    
    enum CodingKeys: String, CodingKey {
        case category = "meals"
    }
}


struct Category :Codable {
    let name : String
    
    enum CodingKeys: String, CodingKey {
        case name = "strCategory"
    }
    
}



struct AreaList :Codable {
    let area : [Area]
    
    enum CodingKeys: String, CodingKey {
        case area = "meals"
    }
}


struct Area :Codable {
    let name : String
    enum CodingKeys: String, CodingKey {
        case name = "strArea"
    }
    
}
