//
//  Config.swift
//  House
//
//  Created by andrew on 4/9/2018.
//  Copyright © 2018年 andrew. All rights reserved.
//

import UIKit

struct Host{
    #if DEBUG
    static var apiBaseUrl:String = Bundle.main.infoDictionary?["APIHost"] as? String ?? "" // No staging env for this yet
    #else
    static var apiBaseUrl:String = Bundle.main.infoDictionary?["APIHost"] as? String ?? ""
    #endif
}
