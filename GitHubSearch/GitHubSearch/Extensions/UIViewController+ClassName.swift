//
//  UIViewController+ClassName.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 21/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    public class func className() -> String? {
        return NSStringFromClass(self).components(separatedBy: ".").last
    }
}
