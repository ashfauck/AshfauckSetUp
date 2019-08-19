//
//  AFUIControl+Extensions.swift
//  Amil Freight
//
//  Created by Ashfauck on 3/22/19.
//  Copyright © 2019 Vagus. All rights reserved.
//

import Foundation
import UIKit

public class Closure {
    @objc let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func addAction (for controlEvents: UIControl.Event, _ closure: @escaping ()->()) {
        let sleeve = Closure(closure)
        addTarget(sleeve, action: #selector(Closure.invoke), for: controlEvents)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
