//
//  ViewController.swift
//  SwiftWeather
//
//  Created by bzsy on 14-9-7.
//  Copyright (c) 2014年 bzsy. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    let url = "http://api.map.baidu.com/telematics/v3/weather"//天气API url
    let ak = ""//百度API ak
    
    
    @IBOutlet var cityLable : UILabel
    @IBOutlet var temperatureLable : UILabel
    @IBOutlet var iconImage : UIImageView
    @IBOutlet var weatherLable : UILabel
    @IBOutlet var dateLable : UILabel
    @IBOutlet var pm25Icon : UIImageView
    @IBOutlet var pm25Lable : UILabel
    @IBOutlet var pm25LeverLable : UILabel
    
    @IBOutlet var weatherNLable : UILabel
    @IBOutlet var temperatureNLable : UILabel
    @IBOutlet var iconNImage : UIImageView
    
    @IBOutlet var weatherNNLable : UILabel
    @IBOutlet var temperatureNNLable : UILabel
    @IBOutlet var iconNNImage : UIImageView
   
    @IBOutlet var loadingIndicator : UIActivityIndicatorView
    
    let locationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let background_blue = UIImage(named: "Background_blue.jpg")
        self.view.backgroundColor = UIColor(patternImage: background_blue)
        
        loadingIndicator.startAnimating()
        
        let singleFingerTap = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        self.view.addGestureRecognizer(singleFingerTap)
        
        //定位
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if (ios8()) {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //重新刷新
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        weatherLable.text = "正在加载..."
        loadingIndicator.hidden = false
        loadingIndicator.startAnimating()
        locationManager.startUpdatingLocation()
    }
    
    //获取天气信息
    func updateWeatherInfo(coordinate: CLLocationCoordinate2D){

        let AFHTTPManager = AFHTTPRequestOperationManager()
        let params = ["location":"\(coordinate.latitude),\(coordinate.longitude)", "output":"json", "ak":ak]
        
        println(params)
        
        AFHTTPManager.GET(url,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                println("JSON: " + responseObject.description!)
                self.updateUISuccess(responseObject as NSDictionary!)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.hidden = true
                self.weatherLable.text = "获取天气信息失败"
            })
    }
    
    func updateUISuccess(jsonResult: NSDictionary!){
        
        loadingIndicator.stopAnimating()
        loadingIndicator.hidden = true
        
        if let results = jsonResult["results"]?[0] as? NSDictionary{
            cityLable.font = UIFont.boldSystemFontOfSize(30)
            cityLable.text = results["currentCity"]? as String
            if let pm25: Int = (results["pm25"]? as String).toInt(){
                pm25Lable.text = ("pm2.5: " as String).stringByAppendingString(results["pm25"]? as String)
                var pm25String:String
                var pm25Iamge:UIImage
                
                if(pm25 <= 50)
                {
                    pm25String = "优"
                    pm25Iamge = UIImage(named: "pm25green")
                }else if (pm25 <= 100){
                    pm25String = "良"
                    pm25Iamge = UIImage(named: "pm25yellow")
                }else if (pm25 <= 150){
                    pm25String = "轻度污染"
                    pm25Iamge = UIImage(named: "pm25orange")
                }else if (pm25 <= 200){
                    pm25String = "中度污染"
                    pm25Iamge = UIImage(named: "pm25red")
                }else if (pm25 <= 300){
                    pm25String = "重度污染"
                    pm25Iamge = UIImage(named: "pm25purple")
                }else{
                    pm25String = "严重污染"
                    pm25Iamge = UIImage(named: "pm25black")
                }
                pm25LeverLable.text = pm25String
                pm25Icon.image = pm25Iamge
            }
            
            if let weather_data_today = results["weather_data"]?[0] as? NSDictionary{
                dateLable.text = weather_data_today["date"]? as String
                temperatureLable.font = UIFont.boldSystemFontOfSize(20)
                temperatureLable.text = ((weather_data_today["temperature"]? as String).stringByAppendingString(" ")).stringByAppendingString(weather_data_today["wind"]? as String)

//  常见返回结果："晴 多云 阴 阵雨 雷阵雨 雷阵雨伴有冰雹 雨夹雪 小雨 中雨 大雨 暴雨 大暴雨 特大暴雨 阵雪 小雪 中雪 大雪 暴雪 雾 冻雨 沙尘暴 小雨转中雨 中雨转大雨 大雨转暴雨 暴雨转大暴雨 大暴雨转特大暴雨 小雪转中雪 中雪转大雪 大雪转暴雪 浮尘 扬沙 强沙尘暴 霾"
                if let weatherString:String  = weather_data_today["weather"]? as? String{
                    weatherLable.font = UIFont.boldSystemFontOfSize(20)
                    weatherLable.text = weatherString
                    updateIcons(weatherString, icon: iconImage, isThin: false)
                }
            }
            if let weather_data_next_day = results["weather_data"]?[1] as? NSDictionary{
                temperatureNLable.text = weather_data_next_day["temperature"]? as String
                if let weatherString:String  = weather_data_next_day["weather"]? as? String{
                    weatherNLable.text = weatherString
                    updateIcons(weatherString, icon: iconNImage, isThin: true)
                }
            }
            if let weather_data_next_next_day = results["weather_data"]?[2] as? NSDictionary{
                temperatureNNLable.text = weather_data_next_next_day["temperature"]? as String
                if let weatherString:String  = weather_data_next_next_day["weather"]? as? String{
                    weatherNNLable.text = weatherString
                    updateIcons(weatherString, icon: iconNNImage, isThin: true)
                }
            }

        }else{
            weatherLable.text = jsonResult["status"]? as String
        }
        
    }
    
    func updateIcons(weatherString: NSString, icon: UIImageView, isThin: Bool){
        if  weatherString.hasSuffix("多云"){
            if(isThin){
                icon.image = UIImage(named: "PartlySunny-thin")
            }else{
                icon.image = UIImage(named: "PartlySunny")
            }
        }
        else if weatherString.hasSuffix("晴"){
            if(isThin){
                icon.image = UIImage(named: "Sun-thin")
            }else{
                icon.image = UIImage(named: "Sun")
            }
        }
        else if weatherString.hasSuffix("雨"){
            if(isThin){
                icon.image = UIImage(named: "Rain-thin")
            }else{
                icon.image = UIImage(named: "Rain")
            }
        }
        else if weatherString.hasSuffix("雷阵雨"){
            if(isThin){
                icon.image = UIImage(named: "Storm-thin")
            }else{
                icon.image = UIImage(named: "Storm")
            }
        }
        else if weatherString.hasSuffix("阴"){
            if(isThin){
                icon.image = UIImage(named: "Cloud-thin")
            }else{
                icon.image = UIImage(named: "Cloud")
            }
        }
        else if weatherString.hasSuffix("雪"){
            if(isThin){
                icon.image = UIImage(named: "Snow-thin")
            }else{
                icon.image = UIImage(named: "Snow")
            }
        }
        else if weatherString.hasSuffix("沙尘暴") || weatherString.hasSuffix("扬沙"){
            if(isThin){
                icon.image = UIImage(named: "Tornado-thin")
            }else{
                icon.image = UIImage(named: "Tornado")
            }
        }
        else if weatherString.hasSuffix("冰雹"){
            if(isThin){
                icon.image = UIImage(named: "Hail-thin")
            }else{
                icon.image = UIImage(named: "Hail")
            }
        }
        else if weatherString.hasSuffix("霾") || weatherString.hasSuffix("雾") || weatherString.hasSuffix("浮尘"){
            if(isThin){
                icon.image = UIImage(named: "Haze-thin")
            }else{
                icon.image = UIImage(named: "Haze")
            }
        }
    }

    //定位
    func locationManager( manager: CLLocationManager!, didUpdateLocations locations: AnyObject[]!){
       
        var location:CLLocation = locations[locations.count-1] as CLLocation
        if (location.horizontalAccuracy > 0) {
            self.locationManager.stopUpdatingLocation()
            updateWeatherInfo(location.coordinate)
        }
    }
    //定位失败
    func locationManager( manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
        loadingIndicator.stopAnimating()
        loadingIndicator.hidden = true
        weatherLable.text = "获取位置信息失败"
    }
    
    //判断系统版本是否iOS8
    func ios8() -> Bool{
        if ( NSFoundationVersionNumber >= NSFoundationVersionNumber10_8 ) {
            return true
        } else {
            return false
        }
    }

}

