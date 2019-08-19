//
//  AFString+Extensions.swift
//  Amil Freight
//
//  Created by Ashfauck on 3/22/19.
//  Copyright © 2019 Vagus. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var removeWhiteSpace: String{
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    var trimNewLineAndWhiteSpace: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
    var isValidEmail: Bool{
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
        
    }
    
    //validate PhoneNumber
    var isPhoneNumber: Bool
    {
        let charcter  = CharacterSet.init(charactersIn: "+0123456789").inverted
        
        var filtered:String? = nil
        
        let inputString = self.components(separatedBy: charcter)
        
        filtered = inputString.joined(separator: "")
        
        return  self == filtered
    }
    
    func toURL() -> URL?
    {
        let urlString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = urlString else { return nil }
        
        return URL(string: url)
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func toDate(with dateFormatter:DateFormatter) -> Date?
    {
        return dateFormatter.date(from: self)
    }
    
    func toDate(dateFormat:String,timeZone:TimeZone? = nil) -> Date?
    {
        let dateFormatter = DateFormatter()
        
        if let timezone = timeZone
        {
            dateFormatter.timeZone = timezone
            dateFormatter.locale = Locale.current
        }
        else
        {
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.locale = Locale.current
        }
        
        dateFormatter.dateFormat = dateFormat

        return dateFormatter.date(from: self)
    }
    
    func currentDate(dateFormat:String) -> Date?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.date(from: self) ?? nil
    }
    
    func getDate(dateFormat:String) -> Date?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.date(from: self) ?? nil
    }
    
    func getStringInitials() -> String
    {
        let nameSeperatedArray = self.components(separatedBy: " ")
        
        if nameSeperatedArray.count > 1
        {
            guard let firstLetter = nameSeperatedArray.first?.first, let secondLetter = nameSeperatedArray[1].first else
            {
                guard let firstLet = nameSeperatedArray.first?.first else {return ""}
                return "\(firstLet)"
            }
            
            return "\(firstLetter)\(secondLetter)".uppercased()
        }
        else
        {
            guard let firstLetter = nameSeperatedArray.first?.first else { return "" }
            
            return "\(firstLetter)".uppercased()
        }
    }
    
    var isBlank : Bool {
        let s = self
        let cset = CharacterSet.newlines.inverted
        let r = s.rangeOfCharacter(from: cset)
        let ok = s.isEmpty || r == nil
        return ok
    }
    
    func addImageBeforeOrAfter(before:String,image:UIImage,after:String) -> NSMutableAttributedString
    {
        let imageAttachment =  NSTextAttachment()
        
        imageAttachment.image = image
        
        imageAttachment.bounds = CGRect(origin: CGPoint.zero, size: image.size)
        
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        
        let completeText = NSMutableAttributedString(string: before)
        
        completeText.append(attachmentString)
        
        let  textAfterIcon = NSMutableAttributedString(string: after)
        
        completeText.append(textAfterIcon)
        
        return completeText
    }
    
    func getCurrencySymbol() -> String?
    {
        let currency = self.uppercased()
        
        if let locale = currency.getLocale()
        {
            return locale.currencySymbol
        }
        
        return nil
    }
    
    func getLocale() -> Locale? {
        
        var locale:Locale? = nil
        
        let locales = Locale.availableIdentifiers
        
        locales.forEach { (localeIdentifier) in
            
            if let code = locale?.currencyCode, self == code
            {
                locale = Locale(identifier: localeIdentifier)
                return
            }
        }
        
        return locale
    }
    
    func getIfHyperLinkString(attributeDict:[NSAttributedString.Key : Any]) -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString(string: self.strippingHtml, attributes: attributeDict)
        
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            
            let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            
            let linkAttributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,NSAttributedString.Key.underlineColor:UIColor.black] as [NSAttributedString.Key : Any]
            
            matches.enumerated().forEach { (index,match) in
                attributedString.addAttributes(linkAttributes, range: match.range)
            }
            
            return attributedString
        }
        catch
        {
            return attributedString
        }
    }
    
    var strippingHtml:String
    {
        let str = self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        
        return str
    }
    
    var stripTimeStamp:String
    {
        let timeStamp = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        
        return timeStamp
    }
    
    func substring(with nsrange: NSRange) -> Substring?
    {
        guard let range = Range(nsrange, in: self) else { return nil }
        
        return self[range]
    }
    
    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
                let stringIndex = String.Index(encodedOffset: index)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    
    //Localization Method
    
    func localized(bundle: Bundle = .main, tableName: String = "Localization") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "\(self)", comment: "")
    }

}
