//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by MacBook Pro on 24/08/2018.
//  Copyright © 2018 MobilePowered. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var movies = ["Seigneur des Anneaux","Avengers Infinity war","Salvation"]
    var somemovies = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //make the searchbar as observable
        searchBar.rx.text
        .orEmpty
        .distinctUntilChanged()//verify if the value is different from the past
        .filter{!$0.isEmpty}
        .throttle(0.5, scheduler: MainScheduler.instance)//wait 0.5 s for changes 
        .subscribe(onNext:{
                element in
            self.somemovies = self.movies.filter{$0.hasPrefix(element)}
            self.tableView.reloadData()
            })
        
    }

}
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return somemovies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = somemovies[indexPath.row]
        return cell!
    }
}

