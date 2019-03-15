//
//  ViewController.swift
//  Circles
//
//  Created by Karol Struniawski on 12/03/2019.
//  Copyright © 2019 Karol Struniawski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(spawnCircle(_:)))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(moveCircle(_:)))
        let tripleTap = UITapGestureRecognizer(target: self, action: #selector(removeCircle(_:)))
        
        doubleTap.delegate = self
        tripleTap.delegate = self
        longPress.delegate = self
        
        doubleTap.name = "Double"
        tripleTap.name = "Triple"
        longPress.name = "Long"
        
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        
        view.addGestureRecognizer(longPress)
    
        tripleTap.numberOfTapsRequired = 3
        view.addGestureRecognizer(tripleTap)
    }

    @objc func spawnCircle(_ tap: UIGestureRecognizer){
        let circle = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        circle.layer.cornerRadius = 50.0
        circle.center = tap.location(in: view)
        circle.backgroundColor = UIColor.randomBrightColor()
        self.view.addSubview(circle)
        circle.alpha = 0.0
        circle.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        UIView.animate(withDuration: 0.2) {
            circle.transform = CGAffineTransform.identity
            circle.alpha = 1.0
        }
    }
    
    //OFFSET OF TAP
    var offsetX : CGFloat = 0.0
    var offsetY : CGFloat = 0.0
    
    @objc func moveCircle(_ pan : UIGestureRecognizer){
        let point = pan.location(in: self.view)
        
        if let circle = self.view.hitTest(point, with: nil){
            if circle == self.view{
                return
            }
            self.view.bringSubviewToFront(circle)
            if pan.state == .began{
                offsetX = pan.location(in: circle).x - 50
                offsetY = pan.location(in: circle).y - 50
                UIView.animate(withDuration: 0.2) {
                    circle.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    circle.alpha = 0.7
                }
            }
            
            if pan.state == .ended || pan.state == .cancelled{
                UIView.animate(withDuration: 0.2) {
                    circle.transform = CGAffineTransform.identity
                    circle.alpha = 1.0
                }
            }
            
            if pan.state == .changed{
                let p = pan.location(in: self.view)
                circle.center = CGPoint(x: p.x - offsetX, y: p.y - offsetY)
            }
        }
    }
    
    @objc func removeCircle(_ tap: UIGestureRecognizer){
        let point = tap.location(in: self.view)
        if let circle = self.view.hitTest(point, with: nil){
            if circle == self.view{
                return
            }
            UIView.animate(withDuration: 0.2, animations: {
                circle.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
                circle.alpha = 0.0
            }) { (rdy) in
                circle.removeFromSuperview()
            }
        }
    }
}

extension ViewController : UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.name == "Triple" && gestureRecognizer.name == "Double"{
            return true
        }else{
            return false
        }
    }
}



extension CGFloat {
    static func random() -> CGFloat {
        return random(min: 0.0, max: 1.0)
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(max > min)
        return min + ((max - min) * CGFloat(arc4random()) / CGFloat(UInt32.max))
    }
}

extension UIColor {
    static func randomBrightColor() -> UIColor {
        return UIColor(hue: .random(),
                       saturation: .random(min: 0.5, max: 1.0),
                       brightness: .random(min: 0.7, max: 1.0),
                       alpha: 1.0)
    }
}
