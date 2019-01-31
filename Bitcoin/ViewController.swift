//
//  ViewController.swift
//  Bitcoin
//
//  Created by Achem Samuel on 11/30/18.
//  Copyright © 2018 Achem Samuel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    

    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    @IBOutlet weak var priceLabel: UILabel!
    let currency = [ "AUD", "BRL", "CAD", "CNY", "EUR", "GBP", "HKD", "IDR", "ILS","JPY", "MXN", "NOK", "NGN", "NZD", "PLN", "RON", "RUB", "SEK", "USD", "ZAR"]
    let currencySymbolArray = ["$", "€", "$", "¥", "£",  "₤", "Kr", "Rp", "R", "En", "Kp", "Wx", "₦", "Pb", "Hi", "Mn", "Na", "Ag", "$", "Br"]
    var finalURL = ""
    var currencySelected = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(currency[row])
        finalURL = baseURL + currency[row]
        print(finalURL)
        getBitcoinData(url: finalURL)
        currencySelected = currencySymbolArray[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currency.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currency[row]
    }
    
    
    func getBitcoinData (url: String) {
        Alamofire.request(url, method: .get)
            .responseJSON {
                response in
                    
                    if response.result.isSuccess{
                        print ("Successfully got price")
                        let bitcoinJSON : JSON = JSON(response.result.value!)
                        self.updateBitcoinPrice(json : bitcoinJSON)
                    }
                    
                    else {
                        print("Error: \(String(describing: response.result.error))")
                        self.priceLabel.text = "Connection Failed"
                    }
                }
        }
    
    func updateBitcoinPrice (json : JSON) {
        if  let priceOfBitcoin = json ["last"].double {
            priceLabel.text = "\(currencySelected) \(priceOfBitcoin)" 
        }
        else {
            priceLabel.text = "Price Unavailable"
        }
        
    }

    }
    


