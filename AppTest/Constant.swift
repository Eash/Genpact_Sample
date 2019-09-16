//
//  Constant.swift
//  AppTest
//
//  Created by Ganesh Kumar on 14/09/19.
//  Copyright © 2019 Nextbrain. All rights reserved.
//

import Foundation
import UIKit


enum FontName: String{
    case regular = "HelveticaNeue"
    case bold = "HelveticaNeue-Bold"
    case medium = "HelveticaNeue-Medium"
}

class Constant{
    
    static func attributeColorString(_ fullstring: String, colorString: String, defaultcolor: UIColor, color: UIColor, font: UIFont) -> NSAttributedString{
        let accountstr = fullstring
        let fontattr = [NSAttributedString.Key.font :font, NSAttributedString.Key.foregroundColor: defaultcolor]
        let mainstring = NSMutableAttributedString(string: accountstr, attributes: fontattr)
        mainstring.setColorForText(colorString, with: color)
        return mainstring
    }
    
    static func hextoRGB (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines as CharacterSet).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)}
        
        if ((cString.count) != 6) {
            return UIColor.gray}
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}


//MARK: - AttributeString Extension
extension NSMutableAttributedString {
    @discardableResult func bold(_ text:String, from:String) -> NSMutableAttributedString {
        let attrs = [NSAttributedString.Key.font : UIFont(name: FontName.bold.rawValue, size: 14.0)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        let boldString = NSMutableAttributedString(string: text, attributes: attrs)
        self.append(boldString)
        return self
    }
    
    @discardableResult func normal(_ text:String, from: String)->NSMutableAttributedString {
        let attrs = [NSAttributedString.Key.font : UIFont(name: FontName.regular.rawValue, size: 14.0)!]
        let normal =  NSMutableAttributedString(string: text, attributes: attrs)
        self.append(normal)
        return self
    }
    
    func setColorForText(_ textToFind: String, with color: UIColor) {
        let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
    }
    
}


