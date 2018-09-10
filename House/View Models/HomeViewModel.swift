//
//  HomeViewModel.swift
//  House
//
//  Created by andrew on 8/9/2018.
//  Copyright © 2018年 andrew. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import RealmSwift

class HomeViewModel {
    let disposeBag = DisposeBag()
    
    var roomsCollection: Variable<JSON> = Variable(JSON.null)
    
    init() {
        SessionManager.sharedManager.roomsCollection.asObservable()
            .filter ({ roomsCollection -> Bool in
                return !roomsCollection.isEmpty
            })
            .subscribe({ str in
                self.roomsCollection.value = JSON(parseJSON: str.element ?? "")
            }).disposed(by: disposeBag)
        
        //update network information
        self.getAllRooms()
        
        //call getWeather at initial
        self.getWeather()
        
        //every 60 seconds update the weather
        Observable<Int>.interval(60, scheduler: MainScheduler.instance)
            .subscribe({ _ in
                self.getWeather()
            }).disposed(by: disposeBag)
    }
    
    func getWeather() {
        APIManager.sharedManager.getWeather()
            .map({ data -> JSON in
                (try? JSON(data: data)) ?? JSON([:])
            })
            .subscribe(onNext: { json in
                if json.dictionaryValue.keys.contains("consolidated_weather") {
                    var temp = 0.0
                    var predictability = 0

                    let array = json["consolidated_weather"].arrayValue
                    array.forEach({ object in
                        //get highest predictability temperature, more accurate
                        if object["predictability"].intValue > predictability {
                            predictability = object["predictability"].intValue
                            temp = object["the_temp"].doubleValue
                        }
                    })

                    self.fetch().filter({ currentFixture -> Bool in
                        return currentFixture.fixture.elementsEqual("AC")
                    }).forEach({ currentFixture in
                        //AC is on but temperature smaller than 25 or
                        //AC is off but temperature higher than 25
                        if currentFixture.status && temp < 25 || !currentFixture.status && temp > 25 {
                            currentFixture.status = !currentFixture.status
                            self.update(fixtureProperties: currentFixture)
                        }
                    })
                }
            }).disposed(by: self.disposeBag)
    }

    func getAllRooms() {
        APIManager.sharedManager.getAllRooms()
            .map({ data -> String in
                data.base64EncodedString()
            })
            .filter({ str -> Bool in
                str.elementsEqual(SessionManager.sharedManager.roomsCollection.value)
            })
            .subscribe(onNext: { str in
                //if the data from internet is change, update local data
                SessionManager.sharedManager.roomsCollection.value = str
            }).disposed(by: self.disposeBag)
    }
    
    func fetch() -> [FixtureProperties] {
        let realm = try? Realm()
        return realm?.objects(FixtureProperties.self)
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
