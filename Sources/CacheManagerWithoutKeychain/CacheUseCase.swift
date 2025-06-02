//
//  CacheUseCase.swift
//  WeatherTestTask
//
//  Created by Александр Иванцов on 01.06.2025.
//

import Foundation

// MARK: - CacheUseCase

public protocol CacheUseCase: AnyObject {

    func save<T: Codable>(data: T, for key: String) throws
    func load<T: Codable>(from key: String) throws -> T?
    func remove(for key: String) throws

}

// MARK: - CacheUseCaseImpl

public final class CacheUseCaseImpl {

    // MARK: - Private properties

    private let cacheConfig: CacheConfig
    private let fileManagerService = FileManagerService.shared

    // MARK: - CacheConfig

    public struct CacheConfig {
        let data: Codable?
        let timeExpiration: Int
        let memoryCapacity: Int

        init(
            data: Codable? = nil,
            timeExpiration: Int,
            memoryCapacity: Int
        ) {
            self.data = data
            self.timeExpiration = timeExpiration
            self.memoryCapacity = memoryCapacity
        }
    }

    // MARK: - Life cycle

    init(cacheConfig: CacheConfig) {
        self.cacheConfig = cacheConfig
    }

}

// MARK: - Public methods

extension CacheUseCaseImpl: CacheUseCase {

    public func save<T: Codable>(data: T, for key: String) throws {
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(data)

        try fileManagerService.save(data: jsonData, to: key)
    }

    public func load<T: Codable>(from key: String) throws -> T? {
        let fileUrl = try fileManagerService.getFileUrl(fileName: key)

        guard fileManagerService.fileExist(from: key) else {
            throw CacheError.fileNotFound(fileName: key, file: #file, line: #line)
        }

        let jsonData = try fileManagerService.loadData(from: key)

        guard let creationDate = fileUrl.creationDate else {
            throw CacheError.creationDateUnavailable(fileName: key, file: #file, line: #line)
        }

        if isCacheExpired(date: creationDate) {
            try remove(for: key)
            throw CacheError.cacheIsExpired(fileName: key, file: #file, line: #line)
        }
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: jsonData)
    }

    public func remove(for key: String) throws {
        do {
            try fileManagerService.removeFile(at: key)
        } catch {
            throw CacheError.fileCanNotDelete(fileName: key, file: #file, line: #line)
        }
    }

}

// MARK: - Private methods

private extension CacheUseCaseImpl {

    func isCacheExpired(date: Date) -> Bool {
        let currentDate = Date()

        return currentDate.timeIntervalSince(date) > TimeInterval(cacheConfig.timeExpiration * 3600)
    }

}
