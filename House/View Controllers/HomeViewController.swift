//
//  HomeViewController.swift
//  House
//
//  Created by andrew on 8/9/2018.
//  Copyright © 2018年 andrew. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON

class HomeViewController: UITableViewController {

    let disposeBag = DisposeBag()
    let vm = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        //register cell
        let nib = UINib(nibName: "CardTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cardCell")

        //remove line separator
        self.tableView.tableFooterView = UIView.init()
        
        //update UI if roomsCollection change
        self.vm.roomsCollection
            .asObservable()
            .filter({ str -> Bool in
                return str.isEmpty
            })
            .subscribe(onNext: { roomsCollection in
                self.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        //update network information
        self.vm.getAllRooms()
        
        //update error ui
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDatasource
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 120
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let json = JSON(parseJSON: self.vm.roomsCollection.value)
        return json["rooms"].dictionaryValue.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as? CardTableViewCell else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let json = JSON(parseJSON: self.vm.roomsCollection.value)
        cell.titleLabel.text = Array(json["rooms"].dictionaryValue.keys)[indexPath.row]
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showFixtureVC", sender: indexPath.row)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFixtureVC" {
            guard let vc = segue.destination as? FixtureViewController,
                let row = sender as? Int else {
                    return
            }
            
            let json = JSON(parseJSON: self.vm.roomsCollection.value)
            let jsonObject = Array(json["rooms"].dictionaryValue)[row]
            vc.vm.title = jsonObject.key
            
            jsonObject.value["fixtures"].arrayValue.forEach { fixture in
                let fixtureProperties = FixtureProperties()
                fixtureProperties.room = vc.vm.title
                fixtureProperties.fixture = fixture.stringValue
                fixtureProperties.key = "\(vc.vm.title)\(fixture.stringValue)"
                fixtureProperties.status = false
                vc.vm.fixturesCollection.value.append(fixtureProperties)
            }
        }
    }

}
