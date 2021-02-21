//
//  SearchRecipeViewController.swift
//  Easy Super Meals
//
//  Created by James Mbugua on 21/02/2021.
//

import UIKit

class SearchRecipeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectedSegment: UISegmentedControl!
    @IBOutlet weak var pickerViewController: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var catList:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set Title
        pickerViewController.delegate = self
        self.navigationItem.title = kSearchTitle
        loadList(selectedSegmentIndex: selectedSegment.selectedSegmentIndex)
    }
    
    
    @IBAction func searchSegmentChanged(_ sender: UISegmentedControl) {
        loadList(selectedSegmentIndex: sender.selectedSegmentIndex)
    }
    
    
    
    func loadList(selectedSegmentIndex:Int) {
        activityIndicator.startAnimating()
        if selectedSegmentIndex == 0{
            ApiClient.requestCategoriesList { (catList, error) in
                self.activityIndicator.stopAnimating()
                if error == nil {
                    self.catList = catList
                    self.pickerViewController.reloadAllComponents()
                }else {
                    self.showAlertDialog(title: "Loading Error", message: error?.localizedDescription ?? "Failed to load data")
                }
            }
        }else if selectedSegmentIndex == 1 {
            ApiClient.requestAreaList { (arealist, error) in
                self.activityIndicator.stopAnimating()
                if error == nil{
                    self.catList = arealist
                    self.pickerViewController.reloadAllComponents()
                }else {
                    self.showAlertDialog(title: "Loading Error", message: error?.localizedDescription ?? "Failed to load data")
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
    
}


extension SearchRecipeViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return catList.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return catList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCat = catList[row]
        // DogAPI.requestRandomImage(breed: selectedBreed,completionHandler: self.handleRandomImageResponse(data:error:))
    }
    
}


