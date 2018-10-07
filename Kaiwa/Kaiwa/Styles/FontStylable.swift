//
//  FontStylable.swift
//  Kaiwa
//
//  Created by Tomoki William Takasawa on 10/7/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

protocol FontStylable {
    func getMediumFont() -> UIFont
    func getSemiboldFont() -> UIFont
    func getBoldFont() -> UIFont
}

extension FontStylable {
    func getMediumFont() -> UIFont {
        return UIFont(name: "SFProDisplay-Medium", size: 17)!
    }
    func getSemiboldFont() -> UIFont {
        return UIFont(name: "SFProDisplay-Semibold", size: 17)!
    }
    func getBoldFont() -> UIFont {
        return UIFont(name: "SFProText-Bold", size: 70)!
    }
}
