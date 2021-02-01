//
//  RoundedButton.swift
//  CoreML_test
//
//  Created by Vitaly Kozlov on 01.02.2021.
//

import UIKit

class RoundedButton: UIButton {

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
