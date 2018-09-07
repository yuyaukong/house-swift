//
//  SessionManager.swift
//  House
//
//  Created by andrew on 8/9/2018.
//  Copyright © 2018年 andrew. All rights reserved.
//

import KeychainAccess
import SwiftyJSON
import RxSwift

class SessionManager {
    static let sharedManager = SessionManager()

    let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "Wiz.House")
    let disposeBag = DisposeBag()
    var roomsCollection:Variable<String> = Variable("")

    init() {
        // Last rooms collection
        if let roomsCollection = self.keychain["roomsCollection"]{
            self.roomsCollection.value = roomsCollection
        }
        
        self.roomsCollection.asObservable()
            .subscribe(onNext: { [weak self] roomsCollection in
                self?.keychain["roomsCollection"] = roomsCollection
            })
            .disposed(by: self.disposeBag)
    }
}
