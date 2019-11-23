//
//  ViewController.swift
//  Bitcoin Price Checker
//
//  Created by Robo Atenaga on 5/26/18.
//  Copyright © 2018 Yamusa Dalhatu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    let base_URL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    
    let currencyArray = ["USD",  "VND", "NGN", "GBP", "CNH", "JPY", "ZWL", "ZAR", "NZD", "HKD", "EUR"]
    let currencySymbolArray = ["$", "₫", "₦", "￡",  "¥", "¥", "z$", "R", "N$", "HK$", "€"]
    
    var currencySelected = ""
    var finalUrl = ""
    
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyPickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


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
        //print(currencyArray[row])
        currencySelected = currencySymbolArray[row]
        finalUrl = base_URL + currencyArray[row]
        
        //print(finalUrl)
        getBitcoinData(url: finalUrl)
        
    }
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getBitcoinData(url: String) {
        
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess{
                print("Success! Got the Bitcoin data.")
                
                let bitcoinJSON : JSON = JSON(response.result.value!)
                self.updateBitcoinData(json: bitcoinJSON)
                //print(weatherJSON)
            }
            else{
                print("Error \(String(describing: response.result.error))")
                self.priceLabel.text = "Connection Issues"
            }
        }
    }
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    
    //Write the updateBitcoinData method here:
    
    func updateBitcoinData(json : JSON){
        
        if let btcResult = json["ask"].double {
            priceLabel.text = "\(currencySelected)\(btcResult)"
        }
        else {
            priceLabel.text = "Price Unavailable"
        }
    }
    
}

