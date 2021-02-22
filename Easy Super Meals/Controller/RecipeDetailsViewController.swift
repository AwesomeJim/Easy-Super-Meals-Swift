//
//  RecipeDetailsViewController.swift
//  Easy Super Meals
//
//  Created by James Mbugua on 21/02/2021.
//

import UIKit

class RecipeDetailsViewController: UIViewController {
    
    //MARK:-Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var webImageView: UIImageView!
    @IBOutlet weak var youTubeImageView: UIImageView!
    @IBOutlet weak var favouriteImageView: UIImageView!
    @IBOutlet weak var selectedSegment: UISegmentedControl!
    @IBOutlet weak var IngredientsView: UIStackView!
    
    @IBOutlet weak var InstructionsTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:-Properties
    
    var shortRecipe:ShortRecipe?
    var ingredients:[RecipeIngredients] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        ApiClient.requestFullRecipe(recipeId: shortRecipe!.id) { (response, error) in
            if error == nil {
                if let recipe = response {
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
    

    
    func populateRecipe(recipe:RestRecipe)  {
        titleLabel.text = recipe.name
        ingredients = recipe.ingredients
        InstructionsTextView.text = recipe.instructions
        tableView.reloadData()
        loadList(selectedSegmentIndex: selectedSegment.selectedSegmentIndex)
    }
    
    func loadList(selectedSegmentIndex:Int) {
        if selectedSegmentIndex == 0{
            IngredientsView.isHidden = false
            InstructionsTextView.isHidden = true
        }else if selectedSegmentIndex == 1 {
            InstructionsTextView.isHidden = false
            IngredientsView.isHidden = true
        }
    }
    
    @IBAction func selecedSegmentValueChanged(_ sender: UISegmentedControl) {
        loadList(selectedSegmentIndex: sender.selectedSegmentIndex)
    }
}


// MARK: ingredients Table View Data Source extention

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
        
    }
    
    
}

