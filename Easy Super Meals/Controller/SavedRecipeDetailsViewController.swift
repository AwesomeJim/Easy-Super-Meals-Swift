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
    @IBOutlet weak var selectedSegment: UISegmentedControl!
    @IBOutlet weak var recipeInstrusctionsTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var webButton: UIButton!
    

    @IBAction func webButtonPressed(_ sender: UIButton) {
    }
    @IBAction func youtubeButton(_ sender: UIButton) {
    }
    @IBAction func favButtonPressed(_ sender: UIButton) {
    }
    /*
     @IBAction func segementIndexChanged(_ sender: UISegmentedControl) {
     }
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
