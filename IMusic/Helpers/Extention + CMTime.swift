//
//  Extention + CMTime.swift
//  IMusic
//
//  Created by Andrey Novikov on 8/5/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Foundation
import AVKit


extension CMTime {
    func convertToString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return  "" }
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds  = totalSeconds % 60
        let minute = totalSeconds / 60
        let timeFormate = String(format: "%02d:%02d", minute, seconds)
        return timeFormate
    }
}
