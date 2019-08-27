//
//  ReposListViewController.swift
//  JakeWhartonRepos
//
//  Created by Radwa Khaled on 8/27/19.
//  Copyright © 2019 Radwa Khaled. All rights reserved.
//

import UIKit
import MBProgressHUD

class ReposListViewController: UIViewController {

    // MARK: - outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - helper variables
    private let reposListPresenter = ReposListPresenter(service: JakeWhartonReposService())

    var  reposArr: [ReposModel] = []
    var offlineReposArr:[Repositories] = []
    
    var refreshControl = UIRefreshControl()
    var page = 1
    var pageSize = 15
    var fetchingMore = false
    let cellSize = 164
    
    var offlineMode = false
    
     // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        reposListPresenter.attachView(view: self)
        
        setTable()
        
        reposListPresenter.getReposData(page: page, pageSize: pageSize)
        
    }
    
    func setTable() {
        
        tableView.register(ReposCell.self, forCellReuseIdentifier: "ReposCell")
        tableView.register(UINib(nibName: "ReposCell",bundle: nil), forCellReuseIdentifier: "ReposCell")
        //        tableView.rowHeight = UITableView.automaticDimension
        //        tableView.estimatedRowHeight = 164
        
        tableView.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "LoadingCell")
        
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    @objc func refreshTable(refreshControl: UIRefreshControl) {
        
        
        page = 1
        self.fetchingMore = false
        reposListPresenter.getReposData(page: page, pageSize: pageSize)
        
        
    }
    

}

 // MARK: - extension for table data source
extension ReposListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if offlineMode {
            return 1
        }else {
            return 2
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if offlineMode {
            return offlineReposArr.count
        }else {
            if section == 0 {
                return reposArr.count
            } else if section == 1 && fetchingMore {
                return 1
            }
        }
       
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if offlineMode {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReposCell", for: indexPath) as! ReposCell
            cell.setOfflineData(model: offlineReposArr[indexPath.row] )
            return cell
            
        }else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReposCell", for: indexPath) as! ReposCell
                cell.setData(model: reposArr[indexPath.row] )
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
                cell.spinner.startAnimating()
                return cell
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if offlineMode {
             return CGFloat(cellSize)
        }else {
            //return UITableView.automaticDimension
            if indexPath.section == 0 {
                return CGFloat(cellSize)
            } else {
                return 50
            }
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !offlineMode {
            let offsetY = tableView.contentOffset.y
            let tableHeight = tableView.frame.size.height
            let contentHeight = tableView.contentSize.height
            
            // call the next page when reach third cell from bottom
            if ((offsetY + tableHeight) >= contentHeight - CGFloat(cellSize * 2) ) && (offsetY > 0)
            {
                if !fetchingMore {
                    page += 1
                    fetchingMore = true
                    tableView.reloadSections(IndexSet(integer: 1), with: .none)
                    reposListPresenter.getReposData(page: page, pageSize: pageSize)
                }
            }
        }
        
    }
    
    
}

extension ReposListViewController: ReposListView {
   
    
   
    func startLoading() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    func finishLoading() {
        MBProgressHUD.hide(for: self.view, animated: true)
        refreshControl.endRefreshing()
    }
    
    func noInternet(error: String) {
        
        refreshControl.endRefreshing()
        MBProgressHUD.hide(for: self.view, animated: true)
        
        reposListPresenter.fetchReposOfflineData()
    }
    
    func getReposData(model: [ReposModel]) {
        
        self.offlineMode = false
        
        if self.page == 1 {
            self.reposArr = model
            
            //offline save
            if model.count != 0 {
                reposListPresenter.saveReposOfflineData(model: model)
            }
            
        } else {
            
            self.fetchingMore = false
            self.reposArr.append(contentsOf: model)
            
            //offline append
            if model.count != 0 {
                reposListPresenter.saveReposOfflineData(model: model)
            }
        }
        
        tableView.reloadData()
        
    }
    
    func failedGetReposData(error: String) {
        Utilities.shared.showAlertMessage(title: "Error", Message: error)
    }
    
    func fetchReposOfflineData(model: [Repositories]) {
        
        if model.count == 0 {
             Utilities.shared.showAlertMessage(title: "No Internet Conection!", Message: "")
        }else {
            self.offlineMode = true
            self.offlineReposArr = model
            self.tableView.reloadData()
        }
       
        
    }
    
    func saveReposOfflineData() {
        
    }
    
    
}
