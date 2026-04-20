//
//  User.swift
//  MPService_Example
//
//  Created by Elias Ferreira on 11/01/23.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let company: Company
}
