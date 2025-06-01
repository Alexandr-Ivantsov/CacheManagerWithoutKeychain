//
//  FileManagerError.swift
//  WeatherTestTask
//
//  Created by Александр Иванцов on 01.06.2025.
//

import Foundation

enum FileManagerError: Error, CustomStringConvertible {
    case missingEncryptionKey(file: String, line: Int)

    var description: String {
        switch self {
        case .missingEncryptionKey(let file, let line):
            return "Missing encryption key for \(file):\(line)"
        }
    }
}
