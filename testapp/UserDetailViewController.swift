//
//  UserDetailViewController.swift
//  testapp
//
//  Created by vplusm on 27.03.15.
//  Copyright (c) 2015 vplusm. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    var urlString:NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let avatarUrl = NSURL(string: self.urlString)
        
        weak var weakSelf = self
        self.userImageView.hnk_setImageFromURL(avatarUrl!, placeholder: UIImage(named:"placeholder"), success: { (image) -> () in
            let avatar = image as UIImage
            weakSelf?.userImageView.image = avatar
        })
    }
}

