//
//  ClockViewController.swift
//  Clock
//
//  Created by Amita Pai on 11/17/15.
//  Copyright © 2015 Amita Pai. All rights reserved.
//

import UIKit

enum ClockType: Int {
    case Default, Theme
}

class ClockViewController: UIViewController, UITabBarDelegate {

    @IBOutlet var clockView: ClockView!
    @IBOutlet var themeClockView: ThemeClockView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        switch item.tag {
        case ClockType.Default.rawValue:
            self.clockView.start()
            self.themeClockView.stop()
            
            self.clockView.hidden = false
            self.themeClockView.hidden = true
        case ClockType.Theme.rawValue:
            self.clockView.stop()
            self.themeClockView.start()
            
            self.clockView.hidden = true
            self.themeClockView.hidden = false
        default:
            self.clockView.stop()
            self.themeClockView.stop()
        }
    }

}

