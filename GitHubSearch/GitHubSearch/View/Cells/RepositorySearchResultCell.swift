//
//  RepositorySearchResultCell.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 21/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class RepositorySearchResultCell: UITableViewCell {
    static let CellIdentifier = "RepositorySearchResultCell"
    let tap = UITapGestureRecognizer()
    var didTapSubscription: Disposable?
    var viewModel: RepositorySearchCellViewModel? {
        didSet {
            let placeholderImage = UIImage(named: "icon_github")
            guard let viewModel = self.viewModel else {
                self.textLabel?.text = nil
                self.detailTextLabel?.text = nil
                self.imageView?.image = placeholderImage
                return
            }
            self.textLabel?.text = viewModel.title
            self.detailTextLabel?.text = viewModel.subtitle
            self.imageView?.load(url: viewModel.avatarUrl)
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView?.addGestureRecognizer(self.tap)
        self.imageView?.isUserInteractionEnabled = true
    }
}
