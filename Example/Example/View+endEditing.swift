//
//  View+endEditing.swift
//  Example
//
//  Created by Vladimir Shutyuk on 12.08.2022.
//

import UIKit
import SwiftUI

extension View {
    func endEditing() {
        UIApplication.shared.windows.forEach { $0.endEditing(false) }
    }
}
