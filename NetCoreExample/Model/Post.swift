//
//  Post.swift
//  NetCoreExample
//
//  Created by Elias Ferreira on 11/01/23.
//

import Foundation

struct Post: Codable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
