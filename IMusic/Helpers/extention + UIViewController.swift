//
//  extention + UIViewController.swift
//  IMusic
//
//  Created by Andrey Novikov on 8/3/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

extension UIViewController {
    static func loadFromSrotyboard<T: UIViewController>() -> T {
        let viewControllerName = String(describing: T.self)
        guard let viewController = UIStoryboard(name: viewControllerName, bundle: nil).instantiateInitialViewController() as? T else { fatalError("Fatal error - no initial view controller with name \(String(describing: T.self))") }
        return viewController
    }
}
