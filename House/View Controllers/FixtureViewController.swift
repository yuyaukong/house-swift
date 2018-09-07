//
//  FixtureViewController.swift
//  House
//
//  Created by andrew on 8/9/2018.
//  Copyright © 2018年 andrew. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FixtureViewController: UITableViewController {
    
    let disposeBag = DisposeBag()
    let vm = FixtureViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        //register cell
        let nib = UINib(nibName: "StatusTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "statusCell")
        
        //remove line separator
        self.tableView.tableFooterView = UIView.init()

        self.tableView.allowsSelection = false

        self.title = self.vm.title
        
        let array = self.vm.fetch(room: self.vm.title)
        self.vm.fixturesCollection.value = self.vm.fixturesCollection.value.map { fixtureProperties -> FixtureProperties in
            let data = array.filter({ object -> Bool in
                object.fixture.elementsEqual(fixtureProperties.fixture)
            })
            if data.count > 0 {
                fixtureProperties.status = data.first?.status ?? false
            }
            return fixtureProperties
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDatasource
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 160
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.fixturesCollection.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "statusCell", for: indexPath) as? StatusTableViewCell else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.titleLabel.text = self.vm.fixturesCollection.value[indexPath.row].fixture
        cell.isLightOn = self.vm.fixturesCollection.value[indexPath.row].status

        cell.switchButton.rx.isOn
            .skip(1)
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { isOn in
                cell.isLightOn = isOn
                self.vm.changeFixtureStatus(row: indexPath.row)
            })
            .disposed(by: self.disposeBag)

        return cell
    }
    
}
