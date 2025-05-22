//
//  User.swift
//  AppsHeroModPanel
//
//  Created by Ildar Khabibullin on 22.05.2025.
//

import Foundation
import SwiftData

@Model
class User {
    @Attribute(.unique) var id: Int
    var name: String
    var username: String
    var email: String
    var phone: String
    var website: String
    
    var isAdmin: Bool = false
    var isBanned: Bool = false
    var avatarData: Data? = nil
    
    var address: Address?
    var company: Company?
    
    init(id: Int, name: String, username: String, email: String, phone: String, website: String) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.phone = phone
        self.website = website
    }
}

extension User: Identifiable {}

@Model
class Address {
    var street: String
    var suite: String
    var city: String
    var zipcode: String
    var geo: Geo?
    
    init(street: String, suite: String, city: String, zipcode: String, geo: Geo? = nil) {
        self.street = street
        self.suite = suite
        self.city = city
        self.zipcode = zipcode
        self.geo = geo
    }
}

@Model
class Geo {
    var lat: String
    var lng: String
    
    init(lat: String, lng: String) {
        self.lat = lat
        self.lng = lng
    }
}

@Model
class Company {
    var name: String
    var catchPhrase: String
    var bs: String
    
    init(name: String, catchPhrase: String, bs: String) {
        self.name = name
        self.catchPhrase = catchPhrase
        self.bs = bs
    }
}
