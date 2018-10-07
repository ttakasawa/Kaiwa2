//
//  ColorStylable.swift
//  Kaiwa
//
//  Created by Tomoki William Takasawa on 10/7/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

protocol ColorStylable {
    func getMainColor() -> UIColor
    func getSecondaryColor() -> UIColor
    func getOverlayColor() -> UIColor
    func getTextColor() -> UIColor
    func getWhiteColor() -> UIColor
}

extension ColorStylable {
    func getMainColor() -> UIColor {
        return UIColor(red: 1.00, green: 0.20, blue: 0.40, alpha: 1.00)
    }
    func getSecondaryColor() -> UIColor {
        return UIColor.lightGray
    }
    func getOverlayColor() -> UIColor {
        return UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
    }
    func getTextColor() -> UIColor {
        return UIColor(red: 1.00, green: 0.20, blue: 0.40, alpha: 1.00)
    }
    func getWhiteColor() -> UIColor {
        return UIColor.white
    }
}
