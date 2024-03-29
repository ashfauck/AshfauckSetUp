//
//  AFNSObject+Extensions.swift
//  Amil Freight
//
//  Created by Ashfauck on 3/22/19.
//  Copyright © 2019 Vagus. All rights reserved.
//

import Foundation
import UIKit
import GameplayKit

extension NSObject
{
    public func stackAlertView(withTitle title: String?, message: String?,delay:Double? = nil,completion: (() -> Void)? = nil)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .cancel) { (isAction) in
            
            guard let completion = completion else { return }
            
            completion()
        }
        
        alert.addAction(action)
        
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        
        if let del = delay {
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + del)
            {
                alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    public func stackConfirmationAlert(withTitle title: String?, message: String?,okBtnName:String? = nil,cancelBtnName:String? = nil,okCompletion: (() -> Void)? = nil,cancelCompletion: (() -> Void)? = nil)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: (okBtnName == nil) ? "Ok": okBtnName ?? "Ok" , style: .default) { (isAction) in
            
            guard let completion = okCompletion else { return }
            
            completion()
        }
        
        let cancelAction = UIAlertAction(title: (cancelBtnName == nil) ? "Cancel": cancelBtnName ?? "Cancel", style: .default) { (isCancelAction) in
            
            guard let completion = cancelCompletion else { return }
            
            completion()
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel =  UIWindow.Level.alert + 1 // 
        alertWindow.makeKeyAndVisible()
        
        DispatchQueue.main.async {
            alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    
    public func randomString(length : Int) -> String {
        let charSet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: charSet) as! [Character]
        let array = shuffled.prefix(length)
        return String(array)
    }
}

extension DispatchQueue
{
    static public func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: ((_ completed:Bool) -> Void)? = nil)
    {
        DispatchQueue.global(qos: .background).async
            {
                background?()
                
                if let completion = completion
                {
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                        completion(true)
                    })
                }
        }
    }
}

extension Double
{
    /// Rounds the double to decimal places value
    public func rounded(toPlaces places:Int) -> Double
    {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension NSMutableData {
    public func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
