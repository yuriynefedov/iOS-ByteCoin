//
//  functions.swift
//  ByteCoin
//
//  Created by Yuriy Nefedov on 30.06.2021.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import Foundation

func prettify(_ number: Double) -> String? {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = 0
    return numberFormatter.string(from: NSNumber(value: number))
}
