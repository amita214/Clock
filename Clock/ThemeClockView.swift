//
//  ThemeClockView.swift
//  Clock
//
//  Created by Amita Pai on 11/17/15.
//  Copyright © 2015 Amita Pai. All rights reserved.
//

import UIKit

extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * CGFloat(M_PI) / 180.0
    }
}

class ThemeClockView: UIControl {
    
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
    
    private let minuteHand = CAShapeLayer()
    private let hourHand = CAShapeLayer()
    
    private var leftFeet: CALayer?
    
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
        
        // add image
        func layer(image: UIImage) -> CALayer {
            let width = self.bounds.width / 2
            let height = 2 * self.bounds.height / 3
            let imageLayer = CALayer()
            imageLayer.contents = image.CGImage
            imageLayer.bounds = CGRectMake(0.0, 0.0, width, height)
            imageLayer.position = clockCenter
            imageLayer.anchorPoint = CGPointMake(0.5, 0.5)
            return imageLayer
        }
        
        self.layer.addSublayer(layer(UIImage(named: "mickey-mouse-no-leg")!))
        
        let width = self.bounds.width / 2
        let height = 2 * self.bounds.height / 3
        self.leftFeet = layer(UIImage(named: "leftFeet")!)
        self.leftFeet?.position = CGPointMake(CGRectGetMidX(self.bounds) + 0.06 * width, CGRectGetMidY(self.bounds) + 0.35 * height)
        self.leftFeet?.anchorPoint = CGPointMake(0.56, 0.85)
        self.layer.addSublayer(self.leftFeet!)
        
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
        
        // add minute hand
        self.minuteHand.bounds = CGRectMake(0.0, 0.0, 55.0, self.bounds.height / 2.25)
        self.minuteHand.contents = UIImage(named: "rightArm")?.CGImage
        self.minuteHand.position = clockCenter
        self.minuteHand.anchorPoint = CGPointMake(0.42, 0.85)
        self.minuteHand.fillColor = UIColor.blackColor().CGColor
        self.minuteHand.shadowOffset = CGSizeMake(0.0, 3.0)
        self.minuteHand.shadowOpacity = 0.3
        self.layer.addSublayer(self.minuteHand)
        
        // add hour hand
        self.hourHand.bounds = CGRectMake(0.0, 0.0, 55.0, self.bounds.height / 3.0)
        self.hourHand.contents = UIImage(named: "leftArm")?.CGImage
        self.hourHand.position = clockCenter
        self.hourHand.anchorPoint = CGPointMake(0.62, 0.8)
        self.hourHand.fillColor = UIColor.blueColor().CGColor
        self.hourHand.shadowOffset = CGSizeMake(0.0, 3.0)
        self.hourHand.shadowOpacity = 0.3
        self.layer.addSublayer(self.hourHand)
        
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
    
    private func animateFeetTapping() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = 0.5
        animation.fromValue = 0
        animation.toValue = -20.degreesToRadians
        animation.autoreverses = true
        animation.repeatCount = .infinity
        self.leftFeet?.addAnimation(animation, forKey: "tappingAnimation")
    }
    
    internal func updateClockHands() {
        let now = NSDate()
        let components = NSCalendar.currentCalendar().components([NSCalendarUnit.Second, NSCalendarUnit.Minute, NSCalendarUnit.Hour], fromDate: now)
        
        self.animateFeetTapping()
        
        let minuteHandRotationAngle = 2 * M_PI * Double(components.minute) / 60
        self.minuteHand.transform = CATransform3DMakeRotation(CGFloat(minuteHandRotationAngle), 0, 0, 1)
        
        let hourHandRotationAngle = 2 * M_PI * Double(60 * components.hour + components.minute) / (12 * 60)
        self.hourHand.transform = CATransform3DMakeRotation(CGFloat(hourHandRotationAngle), 0, 0, 1)
    }
}
