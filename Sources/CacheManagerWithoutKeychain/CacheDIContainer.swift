//
//  CacheDIContainer.swift
//  WeatherTestTask
//
//  Created by Александр Иванцов on 01.06.2025.
//

import Foundation
import Factory

final class CacheDIContainer: SharedContainer {

    // MARK: - Private properties

    private let cacheConfig = CacheUseCaseImpl.CacheConfig(
        timeExpiration: 24,
        memoryCapacity: 1_000_000
    )

    // MARK: - Public properties

    let manager = ContainerManager()

    static var shared = CacheDIContainer()

    // MARK: - Life cycle

    private init() {}

    var cacheUseCase: CacheUseCase {
        CacheUseCaseImpl(cacheConfig: cacheConfig)
    }

}
