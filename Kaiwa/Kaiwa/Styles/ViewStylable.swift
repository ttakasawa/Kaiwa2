//
//  ViewStylable.swift
//  Kaiwa
//
//  Created by Tomoki William Takasawa on 10/7/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

protocol ViewStylable {
    func getButtonCornerRadius() -> CGFloat
    
}

extension ViewStylable {
    func getButtonCornerRadius() -> CGFloat {
        return 25
    }
}
