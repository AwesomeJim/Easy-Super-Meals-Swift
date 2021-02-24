//
//  SavedRecipeDetailsViewController.swift
//  Easy Super Meals
//
//  Created by James Mbugua on 23/02/2021.
//

import UIKit

class SavedRecipeDetailsViewController: UIViewController {

    @IBOutlet weak var recipeBannerImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var youtubeButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var webButton: UIButton!
    @IBOutlet weak var selectedSegment: UISegmentedControl!
    @IBOutlet weak var recipeInstrusctionsTextView: UITextView!
    @IBOutlet weak var IngredientsView: UIStackView!
    
    
    var recipe:Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let selectedRecipe = recipe else {
          return
        }
        if #available(iOS 13.0, *) {
            favButton.setImage(UIImage(systemName: "heart.fill"), for: UIControl.State.selected)
        } else {
            // Fallback on earlier versions  heart_filled
            favButton.setImage(UIImage(named: "heart_filled"), for: UIControl.State.selected)
        }
        populateRecipe(recipe: selectedRecipe)
    }
    
    func populateRecipe(recipe:Recipe)  {
        favButton.isSelected = true
        recipeTitleLabel.text = recipe.name
        self.navigationItem.title = recipe.area! + " - " + recipe.category!
        recipeBannerImageView.image = UIImage(data: recipe.imageThumbData! as Data)
        recipeInstrusctionsTextView.text = recipe.instructions
        showIngredientsorInstructions(selectedSegmentIndex: selectedSegment.selectedSegmentIndex)
    }
    
    func showIngredientsorInstructions(selectedSegmentIndex:Int) {
        if selectedSegmentIndex == 0{
            IngredientsView.isHidden = false
            recipeInstrusctionsTextView.isHidden = true
        }else if selectedSegmentIndex == 1 {
            recipeInstrusctionsTextView.isHidden = false
            IngredientsView.isHidden = true
        }
    }
    
    // -------------------------------------------------------------------------
    //MARK:-Actions
    @IBAction func webButtonPressed(_ sender: UIButton) {
        let sourceUrl = recipe?.source
        if sourceUrl != ""{
            openExternalUrl(url: sourceUrl!)
        }else {
            showAlertDialog(title: "Ooops", message: "Recipe web link seems to be invalid")
        }
    }
    @IBAction func youtubeButton(_ sender: UIButton) {
        let sourceUrl = recipe?.youtubeLink
        if sourceUrl != ""{
            openExternalUrl(url: sourceUrl!)
        }else {
            showAlertDialog(title: "Ooops ...", message: "Recipe youtube links is invalid")
        }
    }
    
    @IBAction func favButtonPressed(_ sender: UIButton) {
        showToast(message:"Recipe is already your Favourtite")
    }
    
    @IBAction func segementIndexChanged(_ sender: UISegmentedControl) {
        showIngredientsorInstructions(selectedSegmentIndex: selectedSegment.selectedSegmentIndex)
    }
    /*
    
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
