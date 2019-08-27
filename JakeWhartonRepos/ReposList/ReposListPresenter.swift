//
//  ReposListPresenter.swift
//  JakeWhartonRepos
//
//  Created by Radwa Khaled on 8/27/19.
//  Copyright © 2019 Radwa Khaled. All rights reserved.
//

import Foundation

class ReposListPresenter{
    
    private let jakeWhartonReposService:JakeWhartonReposService
    weak private var reposListView:ReposListView?
    
    init(service:JakeWhartonReposService) {
        jakeWhartonReposService = service
    }
    
    func attachView(view:ReposListView){
        reposListView = view
    }
    
    func detachView() {
        reposListView = nil
    }
    
    func getReposData(page:Int, pageSize:Int){
        
        reposListView?.startLoading()
        
        jakeWhartonReposService.apiGenaric(service: "users/JakeWharton/repos?page=\(page)&per_page=\(pageSize)", hTTPMethod: .get, success: { (model:[ReposModel]) -> (Void) in
            DispatchQueue.main.async {
                self.reposListView?.finishLoading()
                self.reposListView?.getReposData(model: model)
                
            }
            
        }) { (err, fromServer) -> (Void) in
            if fromServer {
                self.reposListView?.finishLoading()
                print(err)
            }else{
                self.reposListView?.noInternet(error: err)
            }
        }
    }
    
    func fetchReposOfflineData(){
        
        CoreDataManager.sharedManager.fetchAllRepos { (reposArr) in
            self.reposListView?.fetchReposOfflineData(model: reposArr ?? [])
        }
        
    }
    
    func saveReposOfflineData(model: [ReposModel]) {
        for repo in model {
            CoreDataManager.sharedManager.saveRepos(repo: repo)
        }
    }
    
    
}
