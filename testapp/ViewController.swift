//
//  ViewController.swift
//  testapp
//
//  Created by vplusm on 26.03.15.
//  Copyright (c) 2015 vplusm. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var users : NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.users = NSArray()
        self.tableView.rowHeight  = 80
        
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
        
        let cellIdentifier = "BasicCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
//        if cell == nil {
//            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
//        }
        
        let user : NSDictionary = self.users[indexPath.row] as NSDictionary
        
        cell.textLabel?.text = user["login"] as NSString
        cell.detailTextLabel?.text =  user["html_url"] as NSString
        
        let avatar = user["avatar_url"] as NSString
        let avatarUrl = NSURL(string:avatar)

        cell.imageView?.frame = CGRectMake(0, 0, 100, 100)
        cell.imageView?.image = UIImage(named:"placeholder")
        
        cell.imageView?.hnk_setImageFromURL(avatarUrl!, placeholder: UIImage(named:"placeholder"), success: { (image) -> () in
            let avatarImg = image
            cell.imageView?.image = avatarImg
        })
        
//        self.downloadAvatar(avatar, index:indexPath.row, completion: { (index ,image) -> Void in
//            let avatarImg = image
//            let row = index
//
//            let cellIndexPath = NSIndexPath(forRow: index, inSection: 0)
//            var visibleCells = self.tableView.indexPathsForVisibleRows()! as NSArray
//            
//            if visibleCells.containsObject(cellIndexPath) {
//                cell?.imageView?.image = avatarImg
//            } else {
//                cell?.imageView?.image = UIImage(named:"placeholder")
//            }
//        })
        
        return cell
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




