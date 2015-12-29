//
//  ViewController.swift
//  SimpleBucketList
//
//  Created by Jay Ravaliya on 12/28/15.
//  Copyright © 2015 JRav. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    var tableView : UITableView!
    var addButton : UIBarButtonItem!
    var detailsButton : UIBarButtonItem!
    
    var model : Model!
    var archived : Archived!
    
    var longPressGestureRecognizer : UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* Set title */
        self.title = "SBL"
        
        /* Create Model */
        model = Model()
        archived = Archived()
        
        /* Setup TableView */
        tableView = UITableView(frame: self.view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.bounces = true
        self.view.addSubview(tableView)
        
        /* Right bar button */
        addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addData:")
        self.navigationItem.leftBarButtonItem = addButton
        
        detailsButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Organize, target: self, action: "showMenu:")
        self.navigationItem.rightBarButtonItem = detailsButton
        
        /* Gesture Recognizers */
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPress:")
        longPressGestureRecognizer.minimumPressDuration = 1.0
        longPressGestureRecognizer.delegate = self
        tableView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    

    func longPress(gesture : UIGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizerState.Began {
            let point : CGPoint = gesture.locationInView(self.tableView)
            let indexPath : NSIndexPath = self.tableView.indexPathForRowAtPoint(point)!
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.showAlertController(false, data: model.getData()[indexPath.row], index: indexPath.row)
        }
    }
    
    func cellSwipped(gesture : UIGestureRecognizer) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = self.model.getData()[indexPath.row]
        
        if(self.model.getStatus()[indexPath.row] == true) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.model.editStatus(indexPath.row, isArchived: !self.model.getStatus()[indexPath.row])
        
        if tableView.cellForRowAtIndexPath(indexPath)?.accessoryType == UITableViewCellAccessoryType.Checkmark {
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
        }
        else {
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getData().count
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete) {
            self.archived.addData(self.model.getData()[indexPath.row])
            self.model.deleteData(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func addData(sender : UIButton) {
        self.showAlertController(true)
    }
    
    func showAlertController(isAdd : Bool, data : String = "", index : Int = 0) {
        let alertController : UIAlertController = UIAlertController(title: "Add Item", message: "Add a new item to your Bucket List!", preferredStyle: UIAlertControllerStyle.Alert)

        if(isAdd) {
            alertController.title = "Add Item"
            alertController.message = "Add a new item to your Bucket List!"
            alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
                
            }
            alertController.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                let textField : UITextField = alertController.textFields![0] as UITextField!
                self.model.addData(textField.text!)
                self.tableView.reloadData()
            }))
        }
        else {
            alertController.title = "Edit Item"
            alertController.message = "Edit an item in your Bucket List!"
            alertController.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.text = data
            })
            alertController.addAction(UIAlertAction(title: "Edit", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                let textField : UITextField = alertController.textFields![0] as UITextField!
                self.model.editData(index, new: textField.text!)
                self.tableView.reloadData()
            }))
            
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
            
        }))
        self.presentViewController(alertController, animated: true) { () -> Void in
            
        }
        
        
    }
    
    func showMenu(sender : UIButton) {
        let alertController : UIAlertController = UIAlertController(title: "Delete Controller", message: "Manage Deletions", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alertController.addAction(UIAlertAction(title: "Delete Completed Items", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            
            var data = self.model.getData()
            var status = self.model.getStatus()
            var indexPaths : [NSIndexPath] = []
            
            for(var i = 0; i < data.count; i++) {
                if(status[i] == true) {
                    self.archived.addData(data[i])
                    self.model.deleteData(i)
                    indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
                }
            }
            
            self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
            
        }))
        alertController.addAction(UIAlertAction(title: "Show Deleted Items", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            
            self.navigationController?.pushViewController(DeletedViewController(), animated: true)
            
        }))
        alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
            
            
            
        }))
        
        self.presentViewController(alertController, animated: true) { () -> Void in
            
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

