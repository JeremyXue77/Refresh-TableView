//
//  ViewController.swift
//  Refresh TableView
//
//  Created by JeremyXue on 2018/7/3.
//  Copyright © 2018年 JeremyXue. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var data = [1,2,3,4,5]
    
    var refreshControl:UIRefreshControl!
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBAction func refreshData(_ sender: Any) {
        
        refreshControl.beginRefreshing()
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.myTableView.contentOffset = CGPoint(x: 0, y: -self.refreshControl.bounds.height)
        }) { (finish) in
            self.loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "refresh...")
        
        refreshControl.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
        myTableView.addSubview(refreshControl)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "Data #\(data[indexPath.row])"
        
        return cell
    }
    
    // MARK: - Scroll view delegate
    

    // MARK: Reload table view data

    @objc func loadData(){
//        refreshControl.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.refreshControl.endRefreshing()
            for _ in 1...5 {
                self.data.append(self.data.count + 1)
                self.myTableView.insertRows(at: [[0,self.data.count - 1]], with: UITableViewRowAnimation.fade)
            }
            self.myTableView.scrollToRow(at: [0,self.data.count - 1], at: UITableViewScrollPosition.bottom, animated: true)
        }

    }

}

