//
//  ViewController.swift
//  Easy Super Meals
//
//  Created by James Mbugua on 21/02/2021.
//

import UIKit
import CoreData

//MARK:- FavouritesRecipeViewController

class FavouritesRecipeViewController: UIViewController{
    
    /// A table view that displays a list of saved recipes
    @IBOutlet weak var tableView: UITableView!
    
    
    var fetchedResultsController:NSFetchedResultsController<Recipe>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set Title
        tableView.dataSource = self
        tableView.delegate = self
        self.navigationItem.title = kfouariteTitle
        navigationItem.rightBarButtonItem = editButtonItem
        setUpFetchedResultsController()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpFetchedResultsController()
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    //fetch saved data using the fetchedResultsController
    fileprivate func setUpFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Recipe> = Recipe.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: "recipes")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    
    // Deletes the `Recipe` at the specified index path
    func deleteDeleteRecipe(at indexPath: IndexPath) {
        let recipeToDelete = fetchedResultsController.object(at: indexPath)
        DataController.shared.viewContext.delete(recipeToDelete)
        try? DataController.shared.viewContext.save()
    }
    
    func updateEditButtonState() {
        if let section = fetchedResultsController.sections {
            navigationItem.rightBarButtonItem?.isEnabled = section[0].numberOfObjects > 0
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    
    //-----------------------------------------------------------------
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == kNavTosavedRecipeSegue {
            let detailVC = segue.destination as! SavedRecipeDetailsViewController
            detailVC.recipe = sender as? Recipe
        }
    }
    
}
// -------------------------------------------------------------------------
// MARK: - Table view data source
extension FavouritesRecipeViewController:UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let  count = fetchedResultsController.sections?[section].numberOfObjects ?? 0
        if count == 0 {
            tableView.setEmptyView(title: "You don't have any saved Recipes", message: "Your saved Recipes will appear here.", messageImage: #imageLiteral(resourceName: "heart_filled"))
        }
        else {
            tableView.restore()
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aRecipe = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: kSavedRecipeCell, for: indexPath)
        guard aRecipe.imageThumbData != nil else {
            cell.imageView?.image = #imageLiteral(resourceName: "img_placeholder")
            return cell
        }
        // Configure cell
        // Set the name and image
        cell.textLabel?.text = aRecipe.name
        cell.imageView?.image = UIImage(data: aRecipe.imageThumbData! as Data)
        cell.detailTextLabel?.text = aRecipe.area! + " - " + aRecipe.category!
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteDeleteRecipe(at: indexPath)
        default: () // Unsupported
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier:kNavTosavedRecipeSegue, sender: recipe)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


// -------------------------------------------------------------------------
// MARK: -FetchedResults Controller
extension FavouritesRecipeViewController:NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        default: () // Unsupported
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: tableView.insertSections(indexSet, with: .fade)
        case .delete: tableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        default: () // Unsupported
        }
    }
}



