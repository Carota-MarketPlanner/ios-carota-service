//
//  URL+URLConvertible.swift
//  NetCore
//
//  Created by Elias Ferreira on 12/01/23.
//

import Foundation

extension URL: URLConvertible {
    /// Returns `self`.
    public func asURL() -> URL? { self }
}
