//
//  CircleView.swift
//  social
//
//  Created by Jason Bell on 23/06/2017.
//  Copyright © 2017 Cold Entertainment. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
    

    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        
    }

}
