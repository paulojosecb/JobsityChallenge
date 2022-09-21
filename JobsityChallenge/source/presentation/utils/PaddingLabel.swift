//
//  PaddingLabel.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import UIKit

class PaddingLabel: UILabel {

   @IBInspectable var topInset: CGFloat = 8
   @IBInspectable var bottomInset: CGFloat = 8
   @IBInspectable var leftInset: CGFloat = 8
   @IBInspectable var rightInset: CGFloat = 8

   override func drawText(in rect: CGRect) {
      let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
       super.drawText(in: rect.inset(by: insets))
   }

   override var intrinsicContentSize: CGSize {
      get {
         var contentSize = super.intrinsicContentSize
         contentSize.height += topInset + bottomInset
         contentSize.width += leftInset + rightInset
         return contentSize
      }
   }
}
