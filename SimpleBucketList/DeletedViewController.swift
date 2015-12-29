//
//  DeletedViewController.swift
//  SimpleBucketList
//
//  Created by Jay Ravaliya on 12/29/15.
//  Copyright © 2015 JRav. All rights reserved.
//

import UIKit

class DeletedViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView : UITableView!
    var archived : Archived!
    var deleteButton : UIBarButtonItem!
    
    override func viewDidLoad() {
    
        self.title = "Deleted Items"
        self.view.backgroundColor = UIColor.whiteColor()
        
        archived = Archived()
        
        tableView = UITableView(frame: self.view.frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        deleteButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "deleteAll:")
        self.navigationItem.rightBarButtonItem = deleteButton
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell?.textLabel?.text = archived.getData()[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return archived.getData().count
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.None
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    func deleteAll(sender : UIButton) {
        var indexPaths : [NSIndexPath] = []
        
        for(var i = 0; i < self.archived.getData().count; i++) {
            indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
        }
        
        self.archived.deleteAll()
        self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
}
