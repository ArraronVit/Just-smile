//
//  RoundedLabel.swift
//  JustSmile
//
//  Created by Vitaly Kozlov on 02.02.2021.
//

import UIKit

class RoundedLabel: UILabel {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
        self.layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }

}
