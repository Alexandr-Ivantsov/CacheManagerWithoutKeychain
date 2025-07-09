//
//  FileManagerService.swift
//  WeatherTestTask
//
//  Created by Александр Иванцов on 01.06.2025.
//

import Foundation
import CryptoSwift

final class FileManagerService {

    // MARK: - Private properties

    private let fileManager = FileManager.default
    private var encryptionKey: Data?

    // MARK: - Public properties

    static let shared = FileManagerService()

    // MARK: - Life cycle

    private init() {
        let originalKey = "123EncryptionKey123".data(using: .utf8)!
        self.encryptionKey = originalKey.sha256()
    }

    // MARK: - Public methods

    func getLibraryDirectory() -> URL? {
        return fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first
    }

    func getFileUrl(fileName: String) throws -> URL {
        guard let libraryDirectory = getLibraryDirectory() else {
            throw CacheError.directoryNotFound(file: #file, line: #line)
        }

        return libraryDirectory.appendingPathComponent(fileName)
    }

    func createDirectoryIfNeeded(at directoryURL: URL) throws {
        if !fileManager.fileExists(atPath: directoryURL.path) {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        }
    }

    func fileExist(from fileNamePath: String) -> Bool {
        return fileManager.fileExists(atPath: fileNamePath)
    }

    // MARK: - Save

    func save(data: Data, to fileName: String) throws {
        let encryptedData = try encrypt(data: data)
        let url = try getFileUrl(fileName: fileName)
        try encryptedData.write(to: url, options: .atomic)
    }

    // MARK: - Load

    func loadData(from fileName: String) throws -> Data {
        let url = try getFileUrl(fileName: fileName)
        let encryptedData = try Data(contentsOf: url)
        let decryptedData = try decrypt(data: encryptedData)
        
        return decryptedData
    }

    // MARK: - Remove

    func removeFile(at fileName: String) throws {
        let url = try getFileUrl(fileName: fileName)
        if fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(at: url)
        }
    }

    // MARK: - Private methods

    private func encrypt(data: Data) throws -> Data {
        guard let encryptionKey else {
            throw FileManagerError.missingEncryptionKey(file: #file, line: #line)
        }

        let keyBytes = Array(encryptionKey)
        let iv = AES.randomIV(AES.blockSize)
        do {
            let aes = try AES(key: keyBytes, blockMode: CBC(iv: iv), padding: .pkcs7)
            let dataBytes = Array(data)
            let encryptionBytes = try aes.encrypt(dataBytes)

            return Data(iv + encryptionBytes)

        } catch {
            print("Ошибка при инициализации AES: \(error)")
            throw FileManagerError.missingEncryptionKey(file: #file, line: #line)
        }
    }

    private func decrypt(data: Data) throws -> Data {
        guard let encryptionKey = encryptionKey else {
            throw FileManagerError.missingEncryptionKey(file: #file, line: #line)
        }

        let keyBytes = Array(encryptionKey)
        let ivSize = AES.blockSize
        let iv = Array(data.prefix(ivSize))
        let encryptionBytes = Array(data.dropFirst(ivSize))
        let aes = try AES(key: keyBytes, blockMode: CBC(iv: iv), padding: .pkcs7)

        let decryptedBytes = try aes.decrypt(encryptionBytes)
        return Data(decryptedBytes)
    }

}
