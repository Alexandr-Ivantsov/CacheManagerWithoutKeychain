//
//  URL + extension.swift
//  WeatherTestTask
//
//  Created by Александр Иванцов on 01.06.2025.
//

import Foundation

extension URL {

    var creationDate: Date? {
        return try? self.resourceValues(forKeys: [.creationDateKey]).creationDate
    }

}
