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
        self.vm.roomsCollection.asObservable()
            .subscribe(onNext: { roomsCollection in
                self.tableView.reloadData()
            }).disposed(by: disposeBag)        
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
        return self.vm.roomsCollection.value["rooms"].dictionaryValue.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as? CardTableViewCell else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.titleLabel.text = Array(self.vm.roomsCollection.value["rooms"].dictionaryValue.keys)[indexPath.row]
        return cell
    }

}
