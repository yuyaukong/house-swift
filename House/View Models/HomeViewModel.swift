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

class HomeViewModel {
    let disposeBag = DisposeBag()
    
    var roomsCollection: Variable<String> = SessionManager.sharedManager.roomsCollection

    func getAllRooms() {
        APIManager.sharedManager.getAllRooms()
            .map({ data -> String in
                data.base64EncodedString()
            })
            .filter({ str -> Bool in
                str.elementsEqual(self.roomsCollection.value)
            })
            .subscribe(onNext: { str in
                self.roomsCollection.value = str
            }).disposed(by: self.disposeBag)
    }

}
