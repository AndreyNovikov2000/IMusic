//
//  extention + UINib.swift
//  IMusic
//
//  Created by Andrey Novikov on 8/5/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

extension UINib {
    static func loadfromNib<T: UIView>() -> T {
        guard let view = Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?[0] as? T else { fatalError("Fatal error - no initial view with name \(String(describing: T.self))") }
        return view
    }
}
