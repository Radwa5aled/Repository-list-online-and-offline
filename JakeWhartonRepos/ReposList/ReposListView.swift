//
//  ReposListView.swift
//  JakeWhartonRepos
//
//  Created by Radwa Khaled on 8/27/19.
//  Copyright © 2019 Radwa Khaled. All rights reserved.
//

import Foundation

protocol ReposListView:NSObjectProtocol {
    
    func startLoading()
    func finishLoading()
    func noInternet(error:String)
    
    func getReposData(model: [ReposModel])
    func failedGetReposData(error:String)
    
    //offline
    func fetchReposOfflineData(model: [Repositories])
    func saveReposOfflineData()
    
}
