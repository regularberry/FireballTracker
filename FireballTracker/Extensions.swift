//
//  Extensions.swift
//  FireballTracker
//
//  Created by Sean Berry on 3/4/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import UIKit

extension CGRect {
    var localCenter: CGPoint {
        return CGPoint(x: self.width/2, y: self.height/2)
    }
}
