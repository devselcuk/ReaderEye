//
//  CommonView.swift
//  ReaderEye
//
//  Created by MacMini on 5.10.2021.
//

import UIKit




@IBDesignable
class CommonView : UIView {
    
    
    let secondShadowLayer = CAShapeLayer()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xxx()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xxx()
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xxx()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        secondShadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    
    func xxx() {
        layer.cornerRadius = 8
        backgroundColor = UIColor.clear
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 5
        
        if #available(iOS 13.0, *) {
            secondShadowLayer.fillColor = UIColor.systemGray6.cgColor
        } else {
            // Fallback on earlier versions
        }
        
        secondShadowLayer.shadowColor = UIColor.white.cgColor
        secondShadowLayer.shadowOpacity = 0.7
        secondShadowLayer.shadowRadius = 5
        secondShadowLayer.shadowOffset = CGSize(width: -5, height: -5)
        layer.insertSublayer(secondShadowLayer, at: 0)
        
        
        
        
        
        
        
        
    }
    
    
    
}




