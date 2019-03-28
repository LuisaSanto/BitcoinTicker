//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Luisa Santo on 3/27/19.
//  Copyright © 2019 Luisa Santo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbolArray = ["$",
        "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""
    var currencySymbol = ""
    var currencyValue = ""
    
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
    }
    
    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(currencyArray[row])
        finalURL = baseURL + currencyArray[row]
        print(finalURL)
        getBitCoinData(url: finalURL, row: row)
    }
    
    
    func getBitCoinData(url: String, row: Int) {
        Alamofire.request(url, method: .get).responseJSON { response in
                if response.result.isSuccess {
                    print("Sucess! Got the weather data")
                    let bitcoinJSON : JSON = JSON(response.result.value!)
                    self.updateBitCoinData(json: bitcoinJSON, row: row)
                    
                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
        }
        
    }
    
    func updateBitCoinData(json : JSON, row : Int) {
        let tempResult = json["ask"].stringValue
        currencyValue = tempResult
        currencySymbol = currencySymbolArray[row]
        updateUIBitCoinData()
    }
    
    func updateUIBitCoinData() {
        self.bitcoinPriceLabel.text = currencySymbol + currencyValue
    }

}

