//
//  SearchRouter.swift
//  IMusic
//
//  Created by Andrey Novikov on 8/3/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Foundation

protocol SearchRoutingLogic {
    
}

class SearcRouter: NSObject, SearchRoutingLogic {
    
    weak var viewController: SearchDisplayDataLogic?
    
}
