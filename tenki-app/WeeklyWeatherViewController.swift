//
//  WeeklyWeatherViewController.swift
//  tenki-app
//
//  Created by 木村幸 on 2020/01/11.
//  Copyright © 2020 木村幸. All rights reserved.
//

import UIKit

//構造体を作成
struct WeeklyWeatherStatus: Codable {
    
    let date: String?
    let status: String?
    
}

class WeeklyWeatherViewController:UITableViewController{
    var weekly_weather_status_list: [WeeklyWeatherStatus] = []
    let weather_status_list = ["heyaboshi":"部屋干し推奨", "yoku":"よく乾く", "yaya":"やや乾く", "kawaku":"乾く", "taihen":"大変よく乾く"]
    
    //インジケーター
    var activityIndicatorView = UIActivityIndicatorView()
    
    // Screen Size の取得
    var screenWidth = UIScreen.main.bounds.size.width
    var screenHeight = UIScreen.main.bounds.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getWeeklyWeatherStatus()
    }

    
    func getWeeklyWeatherStatus(){
        let url = "http://127.0.0.1:5000/weekly-weather"
        var request = URLRequest(url: Foundation.URL(string: url)!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        session.dataTask(with: request) {
            (data, response, error) in
            
            if error == nil {
                if let urlContent = data{
                    let weathers: [WeeklyWeatherStatus] = try! JSONDecoder().decode([WeeklyWeatherStatus].self, from: urlContent)
                    
                    for i in 0...weathers.count-1 {
                        self.weekly_weather_status_list.append(weathers[i])
                    }
                    
                    DispatchQueue.main.sync {
                        self.tableView.reloadData()
                    }
                }

            }else{
                print(error!)
            }
                
        }.resume()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //cellの数
        return weekly_weather_status_list.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        
        //セルの高さ
        tableView.rowHeight = 100

        cell.textLabel?.text = "\(weekly_weather_status_list[indexPath.row].date!)"
        cell.detailTextLabel?.text = "\(weather_status_list[weekly_weather_status_list[indexPath.row].status!]!)"
        cell.imageView?.image = UIImage(named: "\(weekly_weather_status_list[indexPath.row].status!).png")
        
        return cell
    }
}
