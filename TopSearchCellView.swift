//
//  TopSearchCellView.swift
//  App
//
//  Created by Shaun Yang on 11/17/19.
//  Copyright © 2019 Shaun Yang. All rights reserved.
//

import UIKit
import SwiftyJSON
class TopSearchCellView: UITableViewCell {
    
//    @IBOutlet weak var TopSearchLabel: UILabel!
    
    let label:UILabel = UILabel(frame: CGRect(x: 30, y: 11.5, width: 42, height: 21))
    func setTopcell(_ data:JSON){
        self.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:0.85)
        label.textAlignment = .center
        label.text = data["description"].string
        label.sizeToFit()
        self.contentView.addSubview(label)
        
    }
}
