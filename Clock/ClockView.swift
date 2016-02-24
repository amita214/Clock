//
//  ClockView.swift
//  Clock
//
//  Created by Amita Pai on 11/17/15.
//  Copyright © 2015 Amita Pai. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    class func strawberryColor() -> UIColor {
        return UIColor(r: 255.0, g: 0.0, b: 128.0, a: 1.0)
    }
    
    class func salmonColor() -> UIColor {
        return UIColor(r: 255.0, g: 102.0, b: 102.0, a: 1.0)
    }
    
    class func plumColor() -> UIColor {
        return UIColor(r: 128.0, g: 0.0, b: 128.0, a: 1.0)
    }
    
    class func seaFoamColor() -> UIColor {
        return UIColor(r: 0.0, g: 255.0, b: 128.0, a: 1.0)
    }
    
    class func asparagusColor() -> UIColor {
        return UIColor(r: 128.0, g: 128.0, b: 0.0, a: 1.0)
    }
    
    class func tinColor() -> UIColor {
        return UIColor(r: 127.0, g: 127.0, b: 127.0, a: 1.0)
    }
}

class ClockView: UIControl {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.customize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.customize()
    }
    
    private var updateTimer: NSTimer?
    func start() {
        self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateClockHands", userInfo: nil, repeats: true)
    }
    
    func stop() {
        self.updateTimer?.invalidate()
        self.updateTimer = nil
    }
    
    private let secondHand = CAShapeLayer()
    private let minuteHand = CAShapeLayer()
    private let hourHand = CAShapeLayer()
    
    private func customize() {
        let clockCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        
        func circleLayer(frame: CGRect) -> CAShapeLayer {
            let circle = CAShapeLayer()
            circle.path = UIBezierPath(ovalInRect: frame).CGPath
            circle.bounds = frame
            circle.position = clockCenter
            return circle
        }
        
        // create clock face
        let face = circleLayer(self.bounds)
        face.fillColor = UIColor.salmonColor().CGColor
        face.strokeColor = UIColor.plumColor().CGColor
        face.lineWidth = 4.0
        self.layer.addSublayer(face)
        
        // add ticks
        for i in 1...60 {
            let tick = CAShapeLayer()
            tick.path = (i % 5 == 0) ? UIBezierPath(ovalInRect: CGRectMake(0.0, 0.0, 3.0, 10.0)).CGPath : UIBezierPath(ovalInRect: CGRectMake(0.0, 0.0, 1.0, 5.0)).CGPath
            tick.fillColor = UIColor.plumColor().CGColor
            tick.strokeColor = UIColor.plumColor().CGColor
            
            tick.bounds = CGRectMake(0.0, 0.0, 1.0, self.bounds.height / 2)
            tick.position = clockCenter
            tick.anchorPoint = CGPointMake(0.5, 1.0)
            tick.transform = CATransform3DMakeRotation(CGFloat(2 * M_PI / 60 * Double(i)), 0, 0, 1)
            self.layer.addSublayer(tick)
        }
        
        // write the numbers for hours
        for i in 1...12 {
            let number = CATextLayer()
            number.string = "\(i)"
            number.fontSize = 18.0
            number.alignmentMode = "center"
            number.foregroundColor = UIColor.plumColor().CGColor
            
            number.bounds = CGRectMake(0.0, 0.0, 25.0, self.bounds.height / 2 - 5.0)
            
            let radius = self.bounds.height / 2.0 - 21.0
            let sectionAngle = 2 * M_PI / 12 * Double(i)
            let deltaX = Double(radius) * sin(sectionAngle) + 12.0
            let deltaY = Double(radius) * (1 - cos(sectionAngle) + 0.08)
            number.position = CGPointMake(CGRectGetMidX(self.bounds) + CGFloat(deltaX), CGFloat(deltaY))
            number.anchorPoint = CGPointMake(1, 0)
//            number.anchorPoint = CGPointMake(0.5, 1.0)
//            number.transform = CATransform3DMakeRotation(CGFloat(sectionAngle), 0, 0, 1)
            
            self.layer.addSublayer(number)
        }
        
        // add the second hand
        self.secondHand.bounds = CGRectMake(0.0, 0.0, 3.0, self.bounds.height / 2.0 + 8.0)
        self.secondHand.path = UIBezierPath(roundedRect: self.secondHand.bounds, cornerRadius: 2.0).CGPath
        self.secondHand.position = clockCenter
        self.secondHand.anchorPoint = CGPointMake(0.5, 0.8)
        self.secondHand.fillColor = UIColor.redColor().CGColor
        self.secondHand.shadowOffset = CGSizeMake(0.0, 3.0)
        self.secondHand.shadowOpacity = 0.3
        self.layer.addSublayer(self.secondHand)
        
        // add minute hand
        self.minuteHand.bounds = CGRectMake(0.0, 0.0, 5.0, self.bounds.height / 2.0)
        self.minuteHand.path = UIBezierPath(roundedRect: self.minuteHand.bounds, cornerRadius: 2.0).CGPath
        self.minuteHand.position = clockCenter
        self.minuteHand.anchorPoint = CGPointMake(0.5, 0.8)
        self.minuteHand.fillColor = UIColor.blackColor().CGColor
        self.minuteHand.shadowOffset = CGSizeMake(0.0, 3.0)
        self.minuteHand.shadowOpacity = 0.3
        self.layer.addSublayer(self.minuteHand)
        
        // add hour hand
        self.hourHand.bounds = CGRectMake(0.0, 0.0, 7.0, self.bounds.height / 3.0)
        self.hourHand.path = UIBezierPath(roundedRect: self.hourHand.bounds, cornerRadius: 2.0).CGPath
        self.hourHand.position = clockCenter
        self.hourHand.anchorPoint = CGPointMake(0.5, 0.8)
        self.hourHand.fillColor = UIColor.blueColor().CGColor
        self.hourHand.shadowOffset = CGSizeMake(0.0, 3.0)
        self.hourHand.shadowOpacity = 0.3
        self.layer.addSublayer(self.hourHand)
        
        // add a circle on top
        let circle = circleLayer(CGRectMake(0.0, 0.0, 11.0, 11.0))
        circle.fillColor = UIColor.yellowColor().CGColor
        circle.position = clockCenter
        circle.anchorPoint = CGPointMake(0.5, 0.5)
        self.layer.addSublayer(circle)
        
        // put gradient for glass
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPointMake(0.0, 0.0)
        gradientLayer.endPoint = CGPointMake(1.0, 1.0)
        gradientLayer.frame = self.bounds
        var colors = [CGColorRef]()
        for i in 1...3 {
            colors.append(UIColor.whiteColor().colorWithAlphaComponent(0.1 * CGFloat(i)).CGColor)
        }
        colors.append(UIColor.whiteColor().colorWithAlphaComponent(0.6).CGColor)
        for var i = 3; i > 0; i-- {
            colors.append(UIColor.whiteColor().colorWithAlphaComponent(0.1 * CGFloat(i)).CGColor)
        }
        gradientLayer.colors = colors
        gradientLayer.mask = circleLayer(self.bounds)
        self.layer.addSublayer(gradientLayer)
        
        self.updateClockHands()
    }
    
    internal func updateClockHands() {
        let now = NSDate()
        let components = NSCalendar.currentCalendar().components([NSCalendarUnit.Second, NSCalendarUnit.Minute, NSCalendarUnit.Hour], fromDate: now)
        
        let secondHandRotationAngle = 2 * M_PI * Double(components.second) / 60
        self.secondHand.transform = CATransform3DMakeRotation(CGFloat(secondHandRotationAngle), 0, 0, 1)
        
        let minuteHandRotationAngle = 2 * M_PI * Double(components.minute) / 60
        self.minuteHand.transform = CATransform3DMakeRotation(CGFloat(minuteHandRotationAngle), 0, 0, 1)
        
        let hourHandRotationAngle = 2 * M_PI * Double(60 * components.hour + components.minute) / (12 * 60)
        self.hourHand.transform = CATransform3DMakeRotation(CGFloat(hourHandRotationAngle), 0, 0, 1)
    }
}
