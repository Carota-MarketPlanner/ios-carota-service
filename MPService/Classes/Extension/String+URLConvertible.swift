//
//  String+URLConvertible.swift
//  MPService
//
//  Created by Elias Ferreira on 12/01/23.
//

import Foundation

extension String: URLConvertible {
    /// Returns a `URL` if `self` can be used to initialize a `URL` instance, otherwise throws.
    ///
    /// - Returns: The `URL` initialized with `self`.
    /// - Throws:  An `AFError.invalidURL` instance.
    public func asURL() -> URL? {
        let url = URL(string: self)

        return url
    }
}
