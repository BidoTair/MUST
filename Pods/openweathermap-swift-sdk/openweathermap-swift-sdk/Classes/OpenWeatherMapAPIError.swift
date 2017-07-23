//
//  OpenWeatherMapError.swift
//  Pods
//
//  Created by Ulaş Sancak on 22/03/2017.
//
//

import Foundation

enum OpenWeatherMapAPIError: Error {
    case emptyParameter(description: String)
}

extension OpenWeatherMapAPIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyParameter(let description):
            return description
        }
    }
}
