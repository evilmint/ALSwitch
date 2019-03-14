//
//  ViewController.swift
//  Demo
//
//  Created by Aleksander Lorenc on 14/03/2019.
//  Copyright © 2019 Unwrapped Software. All rights reserved.
//

import UIKit
import ALSwitch

class ViewController: UIViewController {
    @IBOutlet weak var customSwitch: ALSwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        customSwitch.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }

    @objc private func valueChanged() {
        print("Value changed! isOn: \(customSwitch.isOn)")
    }
}

