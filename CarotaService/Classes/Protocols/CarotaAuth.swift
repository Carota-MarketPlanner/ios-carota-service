//
//  CarotaAuth.swift
//  CarotaService
//
//  Created by Elias Ferreira on 24/01/23.
//

import Foundation

public protocol Auth {
    func setAuthorization(_ auth: HTTPAuthentication)
    func clearAuthorization()
}
