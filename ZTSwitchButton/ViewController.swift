//
//  ViewController.swift
//  ZTSwitchButton
//
//  Created by 赵天福 on 2017/8/15.
//  Copyright © 2017年 zt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var switchBtn: ZTSwitchButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        switchBtn.setSwitchOff()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

