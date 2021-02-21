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
    
    // MARK: Properties
    var recipeList:[ShortRecipe] = []
    var catList:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set Title
        pickerViewController.delegate = self
        self.navigationItem.title = kSearchTitle
        loadList(selectedSegmentIndex: selectedSegment.selectedSegmentIndex)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
    
    func loadRecipeList(selectedSegmentIndex:Int, queryString:String) {
        activityIndicator.startAnimating()
        var url :URL?
        if selectedSegmentIndex == 0{
            url = ApiClient.Endpoints.filterbyCategory(queryString).url
            
        }else if selectedSegmentIndex == 1 {
            url = ApiClient.Endpoints.filterbyArea(queryString).url
        }
        guard let requestUrl = url else {
            return
        }
        print("requestUrl   \(requestUrl)")
        ApiClient.requestRecipeList(url: requestUrl, completionHandler: { (recipeList, error) in
            self.activityIndicator.stopAnimating()
            if error == nil {
                self.recipeList = recipeList
                self.tableView.reloadData()
            }else {
                self.showAlertDialog(title: "Loading Error", message: error?.localizedDescription ?? "Failed to load data")
            }
        })
    }
    
}

//MARK:-UIPickerViewDelegate

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
        print("selectedCat   \(selectedCat)")
        loadRecipeList(selectedSegmentIndex: selectedSegment.selectedSegmentIndex, queryString: selectedCat)
    }
    
}

// MARK: Table View Data Source extention

extension SearchRecipeViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kSearchRecipeCell)!
        let recipe = self.recipeList[(indexPath as NSIndexPath).row]
        // Set the name and image
        cell.textLabel?.text = recipe.name
        cell.imageView?.image = UIImage(named: "img_placeholder")
        ApiClient.downloadThumbImage(path:  recipe.imageurl) { data, error in
            guard let data = data else {
                return
            }
            let image = UIImage(data: data)
            cell.imageView?.image = image
            cell.setNeedsLayout()
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shortRecipe = self.recipeList[(indexPath as NSIndexPath).row]
        
        
    }
    
    
}


