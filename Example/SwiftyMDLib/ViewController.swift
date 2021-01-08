//
//  ViewController.swift
//  SwiftyMDLib
//
//  Created by SargisGevorgyan on 01/31/2020.
//  Copyright (c) 2020 SargisGevorgyan. All rights reserved.
//

import UIKit
import SwiftyMDLib

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var str = "12,3"
        var isValid = str.isValidDecimal(maximumFractionDigits: 2)
        print(str, isValid)
        str = "12.3"
        isValid = str.isValidDecimal(maximumFractionDigits: 2)
        print(str, isValid)
        str = "a12,3"
        isValid = str.isValidDecimal(maximumFractionDigits: 2)
        print(str, isValid)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

