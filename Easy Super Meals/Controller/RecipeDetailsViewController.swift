//
//  RecipeDetailsViewController.swift
//  Easy Super Meals
//
//  Created by James Mbugua on 21/02/2021.
//

import UIKit

class RecipeDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var webImageView: UIImageView!
    @IBOutlet weak var youTubeImageView: UIImageView!
    @IBOutlet weak var favouriteImageView: UIImageView!
    @IBOutlet weak var selectedSegment: UISegmentedControl!
    @IBOutlet weak var InstructionsLabel: UILabel!
    @IBOutlet weak var IngredientsView: UIStackView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var shortRecipe:ShortRecipe?
    
    var ingredients:[RecipeIngredients] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        ApiClient.requestFullRecipe(recipeId: shortRecipe!.id) { (response, error) in
            if error == nil {
                if let recipe = response {
                    print("The returened Recipe is \(recipe.name)")
                    self.populateRecipe(recipe: recipe)
                    ApiClient.downloadBannerImage(imageUrl:  recipe.imageUrl) { data, error in
                        guard let data = data else {
                            return
                        }
                        let image = UIImage(data: data)
                        self.bannerImageView.image = image
                    }
                }
            }
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func populateRecipe(recipe:RestRecipe)  {
        titleLabel.text = recipe.name
        ingredients = recipe.ingredients
        InstructionsLabel.text = recipe.instructions
        tableView.reloadData()
        loadList(selectedSegmentIndex: selectedSegment.selectedSegmentIndex)
    }
    
    func loadList(selectedSegmentIndex:Int) {
        if selectedSegmentIndex == 0{
            tableView.isHidden = false
            IngredientsView.isHidden = false
            InstructionsLabel.isHidden = true
        }else if selectedSegmentIndex == 1 {
            tableView.isHidden = true
            InstructionsLabel.isHidden = false
            IngredientsView.isHidden = true
        }
    }
    
}


// MARK: Table View Data Source extention

extension RecipeDetailsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kIngredientsCell)!
        let strIngredient2 = self.ingredients[(indexPath as NSIndexPath).row]
        // Set the name and image
        cell.textLabel?.text = strIngredient2.name
        cell.detailTextLabel?.text = strIngredient2.quantity
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shortRecipe = self.ingredients[(indexPath as NSIndexPath).row]
       
    }
    
    
}

