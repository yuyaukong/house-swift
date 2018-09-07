//
//  FixtureViewModel.swift
//  House
//
//  Created by andrew on 8/9/2018.
//  Copyright © 2018年 andrew. All rights reserved.
//

import RxSwift
import RealmSwift

class FixtureViewModel {
    let disposeBag = DisposeBag()

    var title: String = ""
    var fixturesCollection: Variable<[FixtureProperties]> = Variable([])

    func changeFixtureStatus(row: Int) {
//        APIManager.sharedManager.changeFixtureStatus(room: <#T##String#>, fixture: <#T##String#>, status: <#T##FixtureStatus#>)
//            .subscribe(onNext: { str in
//                self.roomsCollection.value = str
//            }).disposed(by: self.disposeBag)

        let fixtureProperties = self.fixturesCollection.value[row]
        self.fixturesCollection.value = self.fixturesCollection.value.map({ fixtureObject -> FixtureProperties in
            if fixtureObject.room == fixtureProperties.room && fixtureObject.fixture == fixtureProperties.fixture {
                fixtureObject.status = !fixtureObject.status
                self.update(fixtureProperties: fixtureProperties)
            }
            return fixtureObject
        })
    }
    
    func fetch(room: String) -> [FixtureProperties] {
        let realm = try? Realm()
        return realm?.objects(FixtureProperties.self)
            .filter("room == '\(room)'")
            .map({ fixtureProperties in
                // Using unmanaged objects so no need to worry about thread issues of Realm
                return fixtureProperties.unmanagedClone()
            }) ?? []
    }
    
    func update(fixtureProperties:FixtureProperties) {
        let realm = try? Realm()
        
        try? realm?.write {
//            realm?.add(fixtureProperties, update: true)
            realm?.add(fixtureProperties.unmanagedClone(), update: true)
        }
    }
}
