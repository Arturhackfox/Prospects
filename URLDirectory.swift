//
//  URLDirectory.swift
//  Hot Prospects
//
//  Created by Arthur Sh on 07.01.2023.
//

import SwiftUI
import Foundation


extension FileManager {
    static var directory: URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
}


