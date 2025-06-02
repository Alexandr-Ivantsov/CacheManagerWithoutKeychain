//
//  CacheDIContainer.swift
//  WeatherTestTask
//
//  Created by Александр Иванцов on 01.06.2025.
//

import Foundation
import Factory

public final class CacheDIContainer: SharedContainer {

    // MARK: - Private properties

    public let cacheConfig = CacheUseCaseImpl.CacheConfig(
        timeExpiration: 24,
        memoryCapacity: 1_000_000
    )

    // MARK: - Public properties

    public let manager = ContainerManager()

    public static var shared = CacheDIContainer()

    // MARK: - Life cycle

    private init() {}

    public var cacheUseCase: CacheUseCase {
        CacheUseCaseImpl(cacheConfig: cacheConfig)
    }

}
