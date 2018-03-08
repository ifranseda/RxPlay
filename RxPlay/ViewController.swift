//
//  ViewController.swift
//  RxPlay
//
//  Created by Isnan Franseda on 3/9/18.
//  Copyright © 2018 Isnan Franseda. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Observable.of("ASD").map { (a) -> R in
            print(">> ", a)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

