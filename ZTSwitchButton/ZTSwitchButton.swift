//
//  ZTSwitchButton.swift
//  VPNAgent
//
//  Created by 赵天福 on 2017/8/8.
//  Copyright © 2017年 qihoo360. All rights reserved.
//

import UIKit

class ZTSwitchButton: UIView {
    
    var sliderView : UIView!
    var onTxtLabel : UILabel!
    var offTxtLabel : UILabel!
    var onGradientLayer:CAGradientLayer!
    var offLayer:CALayer!
    
    typealias completedBlock = (Bool) -> Void
    
    var completed : completedBlock!
    
    func callBackBlock(block: @escaping (Bool) -> Void) {
        completed = block
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        onGradientLayer = CAGradientLayer.init()
        onGradientLayer.colors = [UIColor.init(red: 242.0/255.0, green: 73.0/255.0, blue: 73.0/255.0, alpha: 1.0).cgColor, UIColor.init(red: 240.0/255/0, green: 48.0/255.0, blue: 138.0/255.0, alpha: 1.0).cgColor]
        onGradientLayer.startPoint = CGPoint(x:0, y:0.5)
        onGradientLayer.endPoint = CGPoint(x:1, y:0.5)
        onGradientLayer.frame = self.bounds
        onGradientLayer.opacity = 0
        self.layer.addSublayer(onGradientLayer)
        
        offLayer = CAGradientLayer.init()
        offLayer.backgroundColor = UIColor.init(red: 40.0/255.0, green: 51.0/255.0, blue: 49/255.0, alpha: 1.0).cgColor
        offLayer.frame = self.bounds
        offLayer.opacity = 0
        self.layer.addSublayer(offLayer)
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.bounds.size.height/2
        
        onTxtLabel = UILabel.init(frame: CGRect(x:26.0, y:26.0, width:86.0, height:20.0))
        onTxtLabel.textAlignment = NSTextAlignment.center
        onTxtLabel.textColor = UIColor.white
        onTxtLabel.font = UIFont.systemFont(ofSize: 14.0)
        onTxtLabel.alpha = 0
        onTxtLabel.text = "实时过滤中"
        self.addSubview(onTxtLabel)
        
        offTxtLabel = UILabel.init(frame: CGRect(x:26.0, y:26.0, width:86.0, height:20.0))
        offTxtLabel.textAlignment = NSTextAlignment.center
        offTxtLabel.textColor = UIColor.white
        offTxtLabel.font = UIFont.systemFont(ofSize: 14.0)
        offTxtLabel.text = "一键开启过滤"
        offTxtLabel.alpha = 0;
        self.addSubview(offTxtLabel)
        
        sliderView = UIView.init(frame: CGRect(x:10.0, y:9.0, width:(self.bounds.size.width - 40.0)/2, height:self.bounds.size.height - 18))
        sliderView.layer.cornerRadius = (self.bounds.size.height - 18)/2;
        sliderView.isUserInteractionEnabled = true
        sliderView.backgroundColor = UIColor.clear
        self.addSubview(sliderView)
        
        setSwitchOff()
        
        let imageV:UIImageView = UIImageView.init(image: UIImage.init(named: "switch"))
        sliderView.addSubview(imageV)
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.tapAction(sender:)))
        sliderView.addGestureRecognizer(tap)
        
        let pan : UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(self.panAction(sender:)))
        sliderView.addGestureRecognizer(pan)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func tapAction(sender : UITapGestureRecognizer) {
        if sliderView.frame.origin.x == 10.0 {
            switchOnAnimation()
        } else if sliderView.frame.origin.x + sliderView.frame.size.width + 10.0 == self.frame.size.width {
            switchOffAnimation()
        }
    }
    
    func panAction(sender : UIPanGestureRecognizer) {
        
        let translation : CGPoint = sender.translation(in: sliderView)
        sender.view?.center = CGPoint(x:(sender.view?.center.x)! + translation.x,y:(sender.view?.center.y)!)
        let scale = (self.bounds.size.width - self.onTxtLabel.bounds.size.width - 26.0*2)/(self.bounds.size.width - self.sliderView.bounds.size.width - 20.0)
        onTxtLabel.center = CGPoint(x:onTxtLabel.center.x - translation.x*scale,y:onTxtLabel.center.y)
        offTxtLabel.center = CGPoint(x:offTxtLabel.center.x - translation.x*scale,y:offTxtLabel.center.y)
        onTxtLabel.alpha = (sliderView.frame.origin.x - 10.0)/(self.bounds.size.width - self.sliderView.bounds.size.width - 20.0)
        offTxtLabel.alpha = 1.0 - onTxtLabel.alpha
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        onGradientLayer.opacity = Float(onTxtLabel.alpha)
        offLayer.opacity = Float(offTxtLabel.alpha)
        CATransaction.commit()
        sender.setTranslation(CGPoint(x:0,y:0), in: sliderView)
        
        if sliderView.frame.origin.x < 10.0 {
            setSwitchOff()
        }
        if sliderView.frame.origin.x > self.bounds.size.width - sliderView.frame.size.width - 10.0 {
            setSwitchOn()
        }
        
        if sender.state == UIGestureRecognizerState.ended {
            panGestureEndAnimation()
        }
    }
    
    func panGestureEndAnimation() {
        if sliderView.center.x < self.bounds.size.width/2 {
            switchOffAnimation()
        } else {
            switchOnAnimation()
        }
    }
    
    func switchOnAnimation() {
        let time = (self.bounds.size.width - sliderView.bounds.size.width - 10.0 - sliderView.frame.origin.x)/(self.bounds.size.width - self.sliderView.bounds.size.width - 20.0)*0.25
        UIView.animate(withDuration: TimeInterval(time),
                       animations: {
                        self.sliderView.frame.origin.x = self.bounds.size.width - self.sliderView.bounds.size.width - 10.0
                        self.onTxtLabel.frame.origin.x = 26.0
                        self.offTxtLabel.frame.origin.x = 26.0
                        self.onTxtLabel.alpha = 1
                        self.offTxtLabel.alpha = 0
                        self.onGradientLayer.opacity = 1
                        self.offLayer.opacity = 0
        })
        { (isFinish) in
             if self.completed != nil {
                self.completed(true)
            }
        }

    }
    
    func switchOffAnimation() {
        let time = (sliderView.frame.origin.x - 10.0)/(self.bounds.size.width - self.sliderView.bounds.size.width - 20.0)*0.25
        UIView.animate(withDuration: TimeInterval(time),
                       animations: {
                        self.sliderView.frame.origin.x = 10.0
                        self.onTxtLabel.frame.origin.x = self.bounds.size.width - self.onTxtLabel.frame.width - 26.0
                        self.offTxtLabel.frame.origin.x = self.bounds.size.width - self.offTxtLabel.frame.width - 26.0
                        self.onTxtLabel.alpha = 0
                        self.offTxtLabel.alpha = 1
                        self.onGradientLayer.opacity = 0
                        self.offLayer.opacity = 1
        })
        { (isFinish) in
            if self.completed != nil {
                self.completed(false)
            }
        }
    }
    
    
    func setSwitchOn() {
        sliderView.frame.origin.x = self.bounds.size.width - self.sliderView.bounds.size.width - 10.0
        onTxtLabel.frame.origin.x = 26.0
        offTxtLabel.frame.origin.x = 26.0
        onTxtLabel.alpha = 1
        offTxtLabel.alpha = 0
        onGradientLayer.opacity = 1
        offLayer.opacity = 0
    }
    
    func setSwitchOff() {
        sliderView.frame.origin.x = 10.0
        onTxtLabel.frame.origin.x = self.bounds.size.width - self.onTxtLabel.frame.width - 26.0
        offTxtLabel.frame.origin.x = self.bounds.size.width - self.offTxtLabel.frame.width - 26.0
        onTxtLabel.alpha = 0
        offTxtLabel.alpha = 1
        onGradientLayer.opacity = 0
        offLayer.opacity = 1
    }
    
}
