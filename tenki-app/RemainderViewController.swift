//
//  RemainderViewController.swift
//  tenki-app
//
//  Created by 木村幸 on 2020/01/18.
//  Copyright © 2020 木村幸. All rights reserved.
//

import UIKit

//構造体を作成

class RemainderViewController:UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 1{
            return 2
        }else{
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            switch component {
            case 0:
                return 24
            case 1:
                return 60
            default:
                return 0
            }
        }else{
            return exponential_choice.count
        }
    }
    
    // ドラムロールの各タイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1{
            switch component {
            case 0:
                return "\(row)時"
            case 1:
                return "\(row)分"
            default:
                return "errrrrr"
            }
        }else{
            return exponential_choice[row]
        }
    }
    
    // ドラムロール選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1{
            switch component {
            case 0:
                time_h = row
            case 1:
                time_m = row
            default:
                break
            }
        }else{
            exponential_id = row
        }
        
    }
    
    // UserDefaults のインスタンス
    let userDefaults = UserDefaults.standard
    
    var time_h:Int?
    var time_m:Int?
    var exponential_id:Int?
    var status:String?
    
    let exponential_choice = ["その日の指標", "次の日の指標"]
    
    let exponential_choice_remainder = ["今日の指標", "明日の指標"]
    
    let weather_status_list = ["heyaboshi":"部屋干し推奨", "yoku":"よく乾く", "yaya":"やや乾く", "kawaku":"乾く", "taihen":"大変よく乾く"]
    
    var alertController: UIAlertController!
    
    
    @IBOutlet weak var remainder_status_label: UILabel!
    @IBOutlet weak var TimePickerView: UIPickerView!
    @IBOutlet weak var ExponentialPickerView: UIPickerView!
    
    @IBOutlet weak var Set: UIButton!
    
    override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
        SetRemainderStatus()
        SetPickerView()
    }
    
    
    @IBAction func set(_ sender: UIButton) {
        if (time_h != nil) && (time_m != nil) && (exponential_id != nil){
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
                                    if self.exponential_id! == 0{
                                        self.status = weather_status.today
                                    }else{
                                        self.status = weather_status.tomorrow
                                    }
                                    

                                    let content = UNMutableNotificationContent()
                                    let center = UNUserNotificationCenter.current()
                                                
                                    //            登録済みの通知を削除
                                    center.removeAllDeliveredNotifications()
                                    if self.status != nil{
                                        content.title = "\(self.exponential_choice_remainder[self.exponential_id!]):\(self.weather_status_list[self.status!]!)";
                                        
                                    }else{
                                        content.title = "ぱや"
                                    }
                                                
                                    content.body = "やほ";
                                    content.sound = UNNotificationSound.default
                                    let date = DateComponents(hour:self.time_h, minute:self.time_m)//(month:7, day:7, hour:12, minute:0)
                                    let trigger = UNCalendarNotificationTrigger.init(dateMatching: date, repeats: true)//1回だけならrepeatsをfalseに
                                    let remainder_request = UNNotificationRequest.init(identifier: "TestNotification", content: content, trigger: trigger)
                                                
                                    center.add(remainder_request)
                                    // Keyを指定して保存
                                    self.userDefaults.set("\(self.time_h!)時\(self.time_m!)分", forKey: "time")
                                    self.userDefaults.set(self.exponential_choice_remainder[self.exponential_id!], forKey: "exponential")
                                    self.userDefaults.synchronize()
                                    self.alert(title:"リマインダーを設定しました")
                                    self.SetRemainderStatus()

            //                        self.activityIndicatorView.stopAnimating()
                                }
                            }
                            
                        }else{
                            print("err")
                        }
                            
                    }.resume()
                
            //以下で登録処理
        }
        
    }
    
    func SetRemainderStatus(){
        if (userDefaults.string(forKey: "time") != nil) && (userDefaults.string(forKey: "exponential") != nil){
            remainder_status_label.text = "\(userDefaults.string(forKey: "time")!)に\(userDefaults.string(forKey: "exponential")!)のリマインダーを設定しています。"
        }else{
            remainder_status_label.text = "リマインダーは設定されていません"
        }
    }
    
    func SetPickerView(){
        TimePickerView.tag = 1
        TimePickerView.delegate = self
        TimePickerView.dataSource = self
        
        ExponentialPickerView.tag = 2
        ExponentialPickerView.delegate = self
        ExponentialPickerView.dataSource = self
    }
    
    func alert(title:String) {
        alertController = UIAlertController(title: title,
                                            message: nil,
                                   preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                       style: .default,
                                       handler: nil))
        present(alertController, animated: true)
    }
    
    func getWeatherStatus(row:Int){
        print(row)
        
    }
}
