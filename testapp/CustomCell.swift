//
//  CustomCell.swift
//  testapp
//
//  Created by vplusm on 27.03.15.
//  Copyright (c) 2015 vplusm. All rights reserved.
//

import UIKit

protocol CustomCellDelegate {
    func customCellDidTapOnUser(cell:CustomCell)
}

class CustomCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userUrlLabel: UILabel!
    
    var delegate:CustomCellDelegate! = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: "onUserTap:")
        tap.numberOfTapsRequired = 1
        self.userImageView?.gestureRecognizers = NSArray(object: tap)
        self.userImageView?.userInteractionEnabled = true
    }
    
    func onUserTap (sender:UITapGestureRecognizer) {
        self.delegate.customCellDidTapOnUser(self)
    }
}