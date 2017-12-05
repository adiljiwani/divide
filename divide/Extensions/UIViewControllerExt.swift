//
//  UIViewControllerExt.swift
//  divide
//
//  Created by Adil Jiwani on 2017-12-05.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentDetail (_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: false, completion: nil)
    }
}
