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
        let selectedFixture = self.fixturesCollection.value[row]
        var status = FixtureStatus.on
        if selectedFixture.status {
            selectedFixture.status = !selectedFixture.status
            status = FixtureStatus.off
        }
        
        APIManager.sharedManager.changeFixtureStatus(room: selectedFixture.room, fixture: selectedFixture.fixture, status: status)
            .subscribe({ str in
                self.update(fixtureProperties: selectedFixture)
            }).disposed(by: self.disposeBag)
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
            realm?.add(fixtureProperties.unmanagedClone(), update: true)
        }
    }
}
