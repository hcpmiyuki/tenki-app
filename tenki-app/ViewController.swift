//
//  ViewController.swift
//  tenki-app
//
//  Created by 木村幸 on 2020/01/10.
//  Copyright © 2020 木村幸. All rights reserved.
//

import UIKit

//構造体を作成
struct WeatherStatus: Codable {
    
    let today: String?
    
    let tomorrow: String?
    
}

class ViewController: UIViewController {

    @IBOutlet weak var today_weather_status: UIImageView!
    
    @IBOutlet weak var today_weather_status_label: UILabel!
    
    @IBOutlet weak var tomorrow_weather_status: UIImageView!
    
    @IBOutlet weak var tomorrow_weather_status_label: UILabel!
    
    
    
    let weather_status_list = ["heyaboshi":"部屋干し推奨", "yoku":"よく乾く", "yaya":"やや乾く", "kawaku":"乾く", "taihen":"大変よく乾く"]
    
    //インジケーター
    var activityIndicatorView = UIActivityIndicatorView()
    
    // Screen Size の取得
    var screenWidth = UIScreen.main.bounds.size.width
    var screenHeight = UIScreen.main.bounds.size.height
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startIndicator()
        getWeatherStatus()
    }

    
    func getWeatherStatus(){
        let url = "http://127.0.0.1:5000/today-tomorrow-weather"
        var request = URLRequest(url: Foundation.URL(string: url)!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        session.dataTask(with: request) {
            (data, response, error) in
            
            if error == nil {
                if let urlContent = data {
                    DispatchQueue.main.async {
                        let weather_status:WeatherStatus = try! JSONDecoder().decode(WeatherStatus.self, from: urlContent)
                        
                        if weather_status.today != nil{
                            self.today_weather_status.image = UIImage(named: "\(weather_status.today!)" + ".png")
                            self.today_weather_status_label.text = self.weather_status_list[weather_status.today!]
                        }
                        
                        if weather_status.tomorrow != nil{
                            self.tomorrow_weather_status.image = UIImage(named: "\(weather_status.tomorrow!)" + ".png")
                            self.tomorrow_weather_status_label.text = self.weather_status_list[weather_status.tomorrow!]
                        }
                        self.activityIndicatorView.stopAnimating()
                    }
                }
            }else{
                print(error!)
            }
                
        }.resume()
        
    }
    
    
    @IBAction func refresh(_ sender: UIButton) {
        activityIndicatorView.startAnimating()
        getWeatherStatus()
    }
    
    
    func startIndicator(){
        //インジケーター準備
        activityIndicatorView.frame = CGRect(x:screenWidth/2, y:screenHeight/2,  width:0, height:0)
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.color = .darkGray
        activityIndicatorView.hidesWhenStopped = true
        self.view.addSubview(activityIndicatorView)
        
    }
    
    
    @IBAction func remained(_ sender: UIButton) {
        //以下で登録処理
        let content = UNMutableNotificationContent()
        content.title = "hogehoge";
        content.body = "swift-saralymanからの通知だよ";
        content.sound = UNNotificationSound.default
        let date = DateComponents(hour:21, minute:48)//(month:7, day:7, hour:12, minute:0)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: date, repeats: true)//1回だけならrepeatsをfalseに
        let request = UNNotificationRequest.init(identifier: "TestNotification", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
    
}

