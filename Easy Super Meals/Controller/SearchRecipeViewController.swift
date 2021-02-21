//
//  SearchRecipeViewController.swift
//  Easy Super Meals
//
//  Created by James Mbugua on 21/02/2021.
//

import UIKit

class SearchRecipeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerViewController: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set Title
        self.navigationItem.title = kSearchTitle
    }
    

    @IBAction func searchSegmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            
        }else if sender.selectedSegmentIndex == 1{
            
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

}
