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
    @IBOutlet weak var selectedSegment: UISegmentedControl!
    @IBOutlet weak var IngredientsView: UIStackView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var youTubeButton: UIButton!
    @IBOutlet weak var webButton: UIButton!
    @IBOutlet weak var InstructionsTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:-Properties
    
    var shortRecipe:ShortRecipe?
    var ingredients:[RecipeIngredients] = []
    var imageData: Data?
    var restRecipe:RestRecipe?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 13.0, *) {
            favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: UIControl.State.selected)
        } else {
            // Fallback on earlier versions  heart_filled
            favouriteButton.setImage(UIImage(named: "heart_filled"), for: UIControl.State.selected)
        }
        guard let recipe = shortRecipe else {
            return
        }
        getRecipeDetails(shortRecipe: recipe)
    }
    
    // -------------------------------------------------------------------------
    //MARK:-Helper Methods
    func getRecipeDetails(shortRecipe:ShortRecipe) {
        ApiClient.requestFullRecipe(recipeId: shortRecipe.id) { (response, error) in
            if error == nil {
                if let recipe = response {
                    self.restRecipe = response
                    self.populateRecipe(recipe: recipe)
                    self.checkIfSaved()
                    ApiClient.downloadBannerImage(imageUrl:  recipe.imageUrl) { data, error in
                        guard let data = data else {
                            return
                        }
                        self.imageData = data
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
        self.navigationItem.title = recipe.area + " - " + recipe.category
        InstructionsTextView.text = recipe.instructions
        tableView.reloadData()
        showIngredientsorInstructions(selectedSegmentIndex: selectedSegment.selectedSegmentIndex)
    }
    
    func showIngredientsorInstructions(selectedSegmentIndex:Int) {
        if selectedSegmentIndex == 0{
            IngredientsView.isHidden = false
            InstructionsTextView.isHidden = true
        }else if selectedSegmentIndex == 1 {
            InstructionsTextView.isHidden = false
            IngredientsView.isHidden = true
        }
    }
    
    /// save recipe to the Core data
    func saveRecipe() {
            let recipe = Recipe(context: DataController.shared.viewContext)
            recipe.name = restRecipe?.name
            recipe.creationDate = Date()
            recipe.id = restRecipe?.id
            recipe.tags = restRecipe?.tags
            recipe.instructions = restRecipe?.instructions
            recipe.imageUrl = restRecipe?.imageUrl
            recipe.imageThumbData = imageData
            recipe.area = restRecipe?.area
            recipe.category = restRecipe?.category
            recipe.source = restRecipe?.source
            recipe.youtubeLink = restRecipe?.youtubeLink
            try? DataController.shared.viewContext.save()
            for ingredient in ingredients {
                let ingre = Ingredients(context: DataController.shared.viewContext)
                ingre.name = ingredient.name
                ingre.quantity = ingredient.quantity
                ingre.recipe = recipe
                try? DataController.shared.viewContext.save()
            }
            favouriteButton.isSelected = true
        
    }
    
    
    func checkIfSaved()   {
        guard let recipeid = restRecipe?.id else { return }
        //to avoid multiple data we chacke if the recipe is already saved
        guard let isRecipeSaved = recipeExists(recipeId: recipeid) else {
            return
        }
        if isRecipeSaved {
            favouriteButton.isSelected = true
        }
    }
    
    // -------------------------------------------------------------------------
    //MARK:-Actions
    
    @IBAction func webButtonPressed(_ sender: UIButton) {
        let sourceUrl = restRecipe?.source
        if sourceUrl != ""{
            openExternalUrl(url: sourceUrl!)
        }else {
            showAlertDialog(title: "Ooops", message: "Recipe web link seems to be invalid")
        }
    }
    
    @IBAction func youtubeButtonPressed(_ sender: UIButton) {
        let sourceUrl = restRecipe?.youtubeLink
        if sourceUrl != ""{
            openExternalUrl(url: sourceUrl!)
        }else {
            showAlertDialog(title: "Ooops ...", message: "Recipe youtube links is invalid")
        }
    }
    
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        if !sender.isSelected {
            saveRecipe()
        }else {
            showToast(message:"Recipe is already saved")
        }
    }
    
    @IBAction func selecedSegmentValueChanged(_ sender: UISegmentedControl) {
        showIngredientsorInstructions(selectedSegmentIndex: sender.selectedSegmentIndex)
    }
}

// -------------------------------------------------------------------------
// MARK: ingredients Table View Data Source extention
extension RecipeDetailsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ingredients.count
    }
    
    //formart cell table
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

