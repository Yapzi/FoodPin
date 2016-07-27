//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Yapzi on 16/5/10.
//  Copyright © 2016年 Yap. All rights reserved.
//

import UIKit
import CoreData

class RestaurantTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    

//    func creatRestaurantSections() {
//        for restaurantName in restaurantNames {
//            let restaurantKey = restaurantName.substringToIndex(restaurantName.startIndex.advancedBy(1))
//            if var restaurantValue = restaurantDict[restaurantKey] {
//                restaurantValue.append(restaurantName)
//                restaurantDict.updateValue(restaurantValue, forKey: restaurantKey)
//            } else {
//                restaurantDict[restaurantKey] = [restaurantName]
//            }
//            let restaurantVisitedValue = [Bool](count: restaurantDict[restaurantKey]!.count, repeatedValue: false)
//            restaurantIsVisited.updateValue(restaurantVisitedValue, forKey: restaurantKey)
//            var restaurantImage = restaurantName.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "")
//            restaurantImage = restaurantImage.stringByReplacingOccurrencesOfString("'", withString: "")
//            restaurantImage = restaurantImage.stringByReplacingOccurrencesOfString("&", withString: "")
//            if var restaurantImageValue = restaurantImages[restaurantKey] {
//                restaurantImageValue.append(restaurantImage)
//                restaurantImages.updateValue(restaurantImageValue, forKey: restaurantKey)
//            } else {
//                restaurantImages[restaurantKey] = [restaurantImage]
//            }
//        }
//        restaurantTitles = [String](restaurantDict.keys)
//        restaurantTitles.sortInPlace({$0 < $1})
//    }
//    var restaurantSections = [String]()
//    
//    func creatRestaurantSection() {
//        for restaurant in restaurants {
//            let restaurantSection = restaurant.name.substringToIndex(restaurant.name.startIndex.advancedBy(1)).uppercaseString
//            restaurantSections.append(restaurantSection)
//        }
//        restaurantSections.sortInPlace( < )
//    }
    

    var restaurants = [Restaurant]()
    var fetchedResulltsController: NSFetchedResultsController!

    @IBAction func unWind(segue: UIStoryboardSegue) {
    }
    
    var restaurantTitles = [String]()
    var restaurantDicts = [String: [Restaurant]]()
    
//    func creatRestaurantSection() {
//        for restaurant in restaurants {
//            let restaurantKey = restaurant.name.substringToIndex(restaurant.name.startIndex.advancedBy(1)).uppercaseString
//            if var restaurantValue = restaurantDicts[restaurantKey] {
//                restaurantValue.append(restaurant)
//                restaurantDicts.updateValue(restaurantValue, forKey: restaurantKey)
//            } else {
//                restaurantTitles.append(restaurantKey)
//                restaurantDicts[restaurantKey] = [restaurant]
//            }
//        }
//        restaurantTitles.sortInPlace( < )
//    }
    
    
    func fetchData() {
        let fetchRequest = NSFetchRequest(entityName: "Restaurant")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: NSSelectorFromString("caseInsensitiveCompare:"))
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            if managedObjectContext.countForFetchRequest(fetchRequest, error: nil) == 0 {
                var restaurant: Restaurant
                for preloadRestaurant in PreLoad.restaurants {
                    restaurant = NSEntityDescription.insertNewObjectForEntityForName("Restaurant", inManagedObjectContext: managedObjectContext) as! Restaurant
                    restaurant.name = preloadRestaurant.name
                    restaurant.type = preloadRestaurant.type
                    restaurant.location = preloadRestaurant.location
                    restaurant.image = UIImagePNGRepresentation(UIImage(named: preloadRestaurant.image)!)
                    restaurant.phoneNumber = preloadRestaurant.phoneNumber
                }
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                }
            }
            fetchedResulltsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: "sectionIdentifier", cacheName: nil)
            fetchedResulltsController.delegate = self
            do {
//                NSFetchedResultsController.deleteCacheWithName("Root") //fetch 前删除 旧 section 缓存
                try fetchedResulltsController.performFetch()
                restaurants = fetchedResulltsController.fetchedObjects as! [Restaurant]
            } catch {
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
//        self.tableView.estimatedRowHeight = 207
//        self.tableView.rowHeight = UITableViewAutomaticDimension
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.hidesBarsOnSwipe = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - tableView
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo: [NSFetchedResultsSectionInfo] = fetchedResulltsController.sections!
        return sectionInfo[section].numberOfObjects
//        if restaurantTitles.count > 0 {
//            let restaurantKey = restaurantTitles[section]
//            if let restaurantValue = restaurantDicts[restaurantKey] {
//            return restaurantValue.count
//            }
//        }
//        return 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo: [NSFetchedResultsSectionInfo] = fetchedResulltsController.sections!
        return sectionInfo[section].name
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! RestaurantTableViewCell
        let fetchedObject = fetchedResulltsController.objectAtIndexPath(indexPath) as! Restaurant
        cell.NameLable.text = fetchedObject.name
        cell.TypeLable.text = fetchedObject.type
        cell.LocationLable.text = fetchedObject.location
        if let imageData = fetchedObject.image {
            cell.ThumbImageView.image = UIImage(data: imageData)
        }
        if let isVisited = fetchedObject.isVisited?.boolValue {
            cell.visitedMark.image = isVisited ? UIImage(named: "checkmark") : nil
        }

        return cell
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResulltsController.sections!.count
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let optionMenu = UIAlertController(title: nil, message: "What Do You Want To Do ?", preferredStyle: UIAlertControllerStyle.ActionSheet)
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel , handler: nil)
//        optionMenu.addAction(cancelAction)
//        let callActionHandler = {(_: UIAlertAction) -> Void in
//            let alertMessage = UIAlertController(title: "Service Unvailable", message: "Sorry, the call feature is not available yet. pleast try again later.", preferredStyle: .Alert)
//            alertMessage.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
//            self.presentViewController(alertMessage, animated: true, completion: nil)
//            }
//        let callAction = UIAlertAction(title: "Call" + "123-000-\(indexPath.row)", style: .Default, handler: callActionHandler)
//        let isVisitedAction = UIAlertAction(title: "I've Been Here", style: .Default, handler: {(_: UIAlertAction) -> Void in
//            let cell = tableView.cellForRowAtIndexPath(indexPath)
//            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
//            let restaurantKey = self.restaurantTitles[indexPath.section]
//            var restaurantVisitedValue = self.restaurantIsVisited[restaurantKey]
//            restaurantVisitedValue![indexPath.row] = true
//            self.restaurantIsVisited.updateValue(restaurantVisitedValue!, forKey: restaurantKey)
//            })
//        let isNotVisitedAction = UIAlertAction(title: "I've Not Been Here", style: .Default, handler: {(_: UIAlertAction) -> Void in
//            let cell = tableView.cellForRowAtIndexPath(indexPath)
//            cell?.accessoryType = .None
//            let restaurantKey = self.restaurantTitles[indexPath.section]
//            var restaurantVisitedValue = self.restaurantIsVisited[restaurantKey]
//            restaurantVisitedValue![indexPath.row] = false
//            self.restaurantIsVisited.updateValue(restaurantVisitedValue!, forKey: restaurantKey)
//            })
//        optionMenu.addAction(isNotVisitedAction)
//        optionMenu.addAction(callAction)
//        optionMenu.addAction(isVisitedAction)
//        self.presentViewController(optionMenu, animated: true, completion: nil)
//        tableView.deselectRowAtIndexPath(indexPath, animated: false)
//    }
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            restaurantNames.removeAtIndex(indexPath.row)
//            let indexSet = NSMutableIndexSet()
//            let restaurantKey = restaurantTitles[indexPath.section]
//            if restaurantDict[restaurantKey]?.count > 1 {
//                restaurantDict[restaurantKey]?.removeAtIndex(indexPath.row)
//                restaurantIsVisited[restaurantKey]?.removeAtIndex(indexPath.row)
//                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//            } else {
//                indexSet.addIndex(indexPath.section)
//                restaurantDict.removeValueForKey(restaurantKey)
//                restaurantIsVisited.removeValueForKey(restaurantKey)
//                restaurantTitles.removeAtIndex(indexPath.section)
//                tableView.deleteSections(indexSet, withRowAnimation: .Fade)
//            }
//        }
//    }
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let socialShare = UITableViewRowAction(style: .Default, title: "Share", handler: {(action, indexPath) -> Void in
            let restaurantToShare = self.fetchedResulltsController.objectAtIndexPath(indexPath) as! Restaurant
            let defautText = "Let's Check It At " + restaurantToShare.name
            if let imageDataToShare = restaurantToShare.image {
                let activityController = UIActivityViewController(activityItems: [defautText, UIImage(data: imageDataToShare)!], applicationActivities: nil)
                self.presentViewController(activityController, animated: true, completion: nil)
            } else {
                let activityController = UIActivityViewController(activityItems: [defautText], applicationActivities: nil)
                self.presentViewController(activityController, animated: true, completion: nil)
            }
        })
        let DeleteRow = UITableViewRowAction(style: .Default, title: "Delete", handler: {(action, indexPath) -> Void in
            let restaurantToDelete = self.fetchedResulltsController.objectAtIndexPath(indexPath) as! Restaurant
            if let managedObjectContext = (UIApplication.sharedApplication().delegate
                as? AppDelegate)?.managedObjectContext {
                managedObjectContext.deleteObject(restaurantToDelete)
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                }
            }
        })
            socialShare.backgroundColor = UIColor(red: 28/255, green: 165/255, blue: 253/255, alpha: 1.0)
            DeleteRow.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
            return [socialShare, DeleteRow]
        }
    
    // MARK: - NSFetchedResultControllerDelegate
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        let indexSet = NSMutableIndexSet()
        indexSet.addIndex(sectionIndex)
        switch type {
        case .Insert:
            tableView.insertSections(indexSet, withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteSections(indexSet, withRowAnimation: .Fade)
        default:
            tableView.reloadData()
        }
    }
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            if let _newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([_newIndexPath], withRowAnimation: .Fade)
            }
        case .Delete:
            if let _indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([_indexPath], withRowAnimation: .Fade)
            }
        case .Update:
            if let _indexPath = indexPath {
                tableView.reloadRowsAtIndexPaths([_indexPath], withRowAnimation: .Fade)
            }
            
        default:
            tableView.reloadData()
        }
        
        restaurants = controller.fetchedObjects as! [Restaurant]
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
        
    }
    // MARK: - showDetailSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let restaurant = fetchedResulltsController.objectAtIndexPath(indexPath) as! Restaurant
                        let destinationController = segue.destinationViewController as! RestaurantDetailViewController
                            destinationController.restaurant = restaurant
            }
        }
    }
}
