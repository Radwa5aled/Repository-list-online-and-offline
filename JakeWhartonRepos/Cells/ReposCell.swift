//
//  ReposCell.swift
//  JakeWhartonRepos
//
//  Created by Radwa Khaled on 8/27/19.
//  Copyright © 2019 Radwa Khaled. All rights reserved.
//

import UIKit

class ReposCell: UITableViewCell {
    
    
    @IBOutlet weak var lblRepoName: UILabel!
    @IBOutlet weak var lblArchived: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var lblWatchersCount: UILabel!
    @IBOutlet weak var lblForksCount: UILabel!
    @IBOutlet weak var lblLicense: UILabel!
    @IBOutlet weak var licenseView: UIView!
    @IBOutlet weak var lblUpdateAt: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(model:ReposModel) {
        
        lblRepoName.text = model.name
        lblDescription.text = model.repoDescription
        lblLanguage.text = model.language
        lblWatchersCount.text = String(model.watchers)
        lblForksCount.text = String(model.forks)
        
        if let date =  model.pushedAt {
            lblUpdateAt.text = "Updated " + Utilities.shared.calculateDateStrToComponent(date:  date)
            lblUpdateAt.isHidden = false
        }else {
            lblUpdateAt.isHidden = true
        }
        
        
        if let license = model.license {
            lblLicense.text = license.name
            licenseView.isHidden = false
        }else {
            licenseView.isHidden = true
        }
        
        if model.archived {
            lblArchived.isHidden = false
        }else {
            lblArchived.isHidden = true
        }
    }
    
    func setOfflineData(model:Repositories) {
        
        lblRepoName.text = model.name
        lblDescription.text = model.repoDescription
        lblLanguage.text = model.language
        lblWatchersCount.text = String(model.watchers)
        lblForksCount.text = String(model.forks)
        if let date =  model.pushedAt {
            lblUpdateAt.text = "Updated " + Utilities.shared.calculateDateStrToComponent(date:  date)
            lblUpdateAt.isHidden = false
        }else {
            lblUpdateAt.isHidden = true
        }
        
        
        if let license = model.licenseName {
            lblLicense.text = license
            licenseView.isHidden = false
        }else {
            licenseView.isHidden = true
        }
        
        if model.archived {
            lblArchived.isHidden = false
        }else {
            lblArchived.isHidden = true
        }
    
    }
    
}
