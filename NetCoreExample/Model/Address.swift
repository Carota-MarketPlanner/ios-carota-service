//
//  Address.swift
//  NetCoreExample
//
//  Created by Elias Ferreira on 11/01/23.
//

import Foundation

struct Address: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
}
