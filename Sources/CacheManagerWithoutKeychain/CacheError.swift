//
//  CacheError.swift
//  WeatherTestTask
//
//  Created by Александр Иванцов on 01.06.2025.
//

import Foundation

enum CacheError: Error, CustomStringConvertible {
    case fileNotFound(fileName: String, file: String, line: Int)
    case fileCanNotDelete(fileName: String, file: String, line: Int)
    case directoryNotFound(file: String, line: Int)
    case creationDateUnavailable(fileName: String, file: String, line: Int)
    case cacheIsExpired(fileName: String, file: String, line: Int)
    case unknowError(message: String, file: String, line: Int)

    var description: String {
        switch self {
        case .fileNotFound(let fileName, let file, let line):
            return "\(fileName) - Файл не найден в \(file), строка \(line)"
        case .fileCanNotDelete(let fileName, let file, let line):
            return "\(fileName) - Не удалось удалить файл в \(file), строка \(line)"
        case .directoryNotFound(let file, let line):
            return "Не удалось получить каталог документов. \(file) - \(line)"
        case .creationDateUnavailable(let fileName, let file, let line):
            return "\(fileName) - Не удалось получить дату создания файла в \(file), строка \(line)"
        case .cacheIsExpired(let fileName, let file, let line):
            return "\(fileName) - Кэш истек в \(file), строка \(line)"
        case .unknowError(let message, let file, let line):
            return "\(message) - Неизвестная ошибка в \(file), строка \(line)"
        }
    }
}
