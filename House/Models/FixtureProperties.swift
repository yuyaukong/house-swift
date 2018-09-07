//
//  FixtureProperties.swift
//  House
//
//  Created by andrew on 8/9/2018.
//  Copyright © 2018年 andrew. All rights reserved.
//

import RealmSwift
import ObjectMapper

class FixtureProperties: Object {
    @objc dynamic var room:String = ""
    @objc dynamic var fixture:String = ""
    @objc dynamic var key:String = ""
    @objc dynamic var status:Bool = false

    override static func primaryKey() -> String? {
        return "key"
    }

    func unmanagedClone() -> FixtureProperties {
        let fixtureProperties = FixtureProperties(value: self)
        fixtureProperties.room = self.room
        fixtureProperties.fixture = self.fixture
        fixtureProperties.key = self.key
        fixtureProperties.status = self.status
        return fixtureProperties
    }
}
