SwiftWeather
============

Swift语言实现的天气软件

天气API：http://developer.baidu.com/map/index.php?title=car/api/weather
参考：https://github.com/JakeLin/SwiftWeather
图标来源：https://github.com/kickstandapps/WeatherIcons

Screenshots:
https://raw.githubusercontent.com/bzsy/SwiftWeather/master/Screenshots/Main.png


使用了百度的天气API，需要在SwiftWeather / ViewController.swift中的let ak = ""填写申请到的ak，ak需要到『天气API』网页自行申请


以下引用自『参考』：
## Used features
* Swift Programming Language
* CocoaPods
* AFNetworking
* Core Location

## How to build
Because the app uses CocoaPods, we need to run `pod install` to install all the pods.

1. Open Terminal app.
2. Change directory to the project folder. `cd $project_dir`
3. List `ls` all the file to check whether *Podfile* file is in the folder? 
4. If the *Podfile* has been found, then execute `pod install`
5. If the Mac OS doesn't have CocoaPods installed. Please follow [CocoaPods Getting Started](http://guides.cocoapods.org/using/getting-started.html) to install.
6. Once complete installation, open *Swift Weather.xcworkspace* file with Xcode 6.
7. Press *Cmd + B* to build the app.
8. Press *Cmd + R* to run the app on Simulator.
