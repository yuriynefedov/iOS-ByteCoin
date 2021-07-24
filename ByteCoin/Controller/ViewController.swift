//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    var currentCurrency = "USD"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
}


extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentCurrency = coinManager.currencyArray[row]
        print("Getting info for \(currentCurrency)...")
        coinManager.getCoinPrice(for: currentCurrency)
    }
}


extension ViewController: CoinManagerDelegate {
    func managerDidUpdateRate(_ coinManager: CoinManager, with rate: Double) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = prettify(rate)
            self.currencyLabel.text = self.currentCurrency
            print("here")
        }
    }
    
    func managerDidFailWithError(_ error: Error) {
        print("Coin Manager object returned an error:\n\(error)")
    }
}

