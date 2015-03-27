//
//  ViewController.swift
//  testapp
//
//  Created by vplusm on 26.03.15.
//  Copyright (c) 2015 vplusm. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, CustomCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    var users : NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.users = NSArray()
        self.tableView.rowHeight  = 80
        self.tableView.delegate = self
        self.downloadUserWithCompletion { () -> Void in
            
        }
    }
    
    func downloadUserWithCompletion(completion: () -> Void) {
        
        let url = NSURL(string: "https://api.github.com/users")
        var request = NSMutableURLRequest(URL: url!, cachePolicy:.ReloadIgnoringLocalAndRemoteCacheData , timeoutInterval: 60)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if (error == nil)
            {
                var error:NSErrorPointer = nil
                var dict: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)
                
                var array:NSArray = dict as NSArray
                self.users = array
                self.tableView.reloadData()
                
            }
            else
            {
                let alert = UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
        }
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Return the number of rows in the section
        return self.users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)  -> UITableViewCell {
        
        let cellIdentifier = "CustomCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as CustomCell
        
        let user = self.users[indexPath.row] as NSDictionary
        
        cell.usernameLabel.text = user["login"] as NSString
        cell.userUrlLabel.text  = user["html_url"] as NSString

        let avatar    = user["avatar_url"] as NSString
        let avatarUrl = NSURL(string:avatar)
        
        cell.userImageView.image = UIImage(named:"placeholder")
        
        cell.userImageView.hnk_setImageFromURL(avatarUrl!, placeholder: UIImage(named:"placeholder"), success: { (image) -> () in
            cell.userImageView.image = image
        })
        
        cell.delegate = self
        
        return cell
    }
    
    func customCellDidTapOnUser(cell:CustomCell) {
        let indexPath : NSIndexPath = self.tableView.indexPathForCell(cell)!
        let user = self.users[indexPath.row] as NSDictionary
        
        let detailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserDetailViewController") as UserDetailViewController
        detailViewController.urlString = user["avatar_url"] as NSString
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.loadImageForVisibleCells()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.loadImageForVisibleCells()
        }
    }
    
    func loadImageForVisibleCells ()
    {
        let visibleCells = self.tableView.visibleCells() as NSArray
        
        visibleCells.enumerateObjectsUsingBlock { (object, idx, stop) -> Void in
            let cell      = object as CustomCell

            let indexPath = self.tableView .indexPathForCell(cell) as NSIndexPath?
            let userInfo  = self.users.objectAtIndex(indexPath!.row) as NSDictionary
            let avatar    = userInfo["avatar_url"] as NSString
            let avatarUrl = NSURL(string:avatar)
            
            cell.userImageView.hnk_setImageFromURL(avatarUrl!, placeholder: UIImage(named:"placeholder"), success: { (image) -> () in
                cell.userImageView.image = image
            })
            
        }
    }
    
    func downloadAvatar(name:NSString, index:NSInteger, completion: (index : NSInteger ,image : UIImage) -> Void)
    {
        let url = NSURL(string: name)
        var request = NSMutableURLRequest(URL: url!, cachePolicy:.UseProtocolCachePolicy , timeoutInterval: 60)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if (error == nil)
            {
                let avatarImage = UIImage(data: data)
                completion(index: index, image: avatarImage!)
            }
        }
    }
}




