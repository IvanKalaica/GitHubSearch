//
//  FormViewController+Extensions.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 21/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import Eureka

typealias TitleValuePair = (title: String, value: String?)

extension FormViewController {
    func set(_ titleValuePair: TitleValuePair, forTag: String) {
        guard let row = self.form.rowBy(tag: forTag) as? LabelRow else { return }
        row.value = titleValuePair.value
        row.title = titleValuePair.title
        row.reload()
    }
}

class EurekaLogoView: UIView {
    let imageView: UIImageView
    override init(frame: CGRect) {
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 130))
        self.imageView.image = UIImage(named: "icon_github")
        self.imageView.autoresizingMask = .flexibleWidth
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: 320, height: 130)
        self.imageView.contentMode = .scaleAspectFit
        addSubview(self.imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
