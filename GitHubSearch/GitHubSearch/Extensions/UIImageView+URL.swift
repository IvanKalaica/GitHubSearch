//
//  UIImageView+URL.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 23/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import UIKit
import AlamofireImage

extension UIImageView {
    func load(url: String) {
        let placeholderImage = UIImage(named: "icon_github")
        if let url = URL(string: url) {
            self.af_setImage(
                withURL: url,
                placeholderImage: placeholderImage,
                filter: nil,
                progress: nil,
                progressQueue: DispatchQueue(label: "GitHubSearch.IconDownload.Queue"),
                imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
                runImageTransitionIfCached: true) { [weak self] in self?.image = $0.result.value }
        } else {
            self.image = placeholderImage
        }
    }
}
