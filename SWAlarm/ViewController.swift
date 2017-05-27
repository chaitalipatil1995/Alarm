//
//  ViewController.swift
//  SWAlarm
//
//  Created by Amesten Systems on 25/05/17.
//  Copyright © 2017 Amesten Systems. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, cellDelegateProtocol {
    
    
    
    var timer = Timer()
    var repeatTimer = Timer()

    var alarms : [NSManagedObject] = []
    var audioPlayer: AVAudioPlayer!

    var compareTimeString = NSString()
    var time = String()

    
    @IBOutlet var alarmsTableView: UITableView!
    
    //MARK: - View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alarmsTableView.backgroundColor = UIColor.clear
        self.automaticallyAdjustsScrollViewInsets = false
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.view.backgroundColor = UIColor.black
    }
    
    func update() {

        self.repeatTimer.invalidate()

        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let result = formatter.string(from: date)
        
        compareTimeString = result as NSString
        
        print(alarms.count)
        
        for i in 0 ..< alarms.count {
            
            let alarmSTring = alarms[i]
            
            time = (alarmSTring.value(forKey: "time") as? String)!
            let ringtone = alarmSTring.value(forKey: "ringtone") as? String

            if time == compareTimeString as String {
                
                let path = Bundle.main.path(forResource: ringtone, ofType: "mp3")
                let fileURL = NSURL(fileURLWithPath: path!)
                do {
                    try audioPlayer =  AVAudioPlayer(contentsOf: fileURL as URL)
                } catch {
                    print("error")
                }
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                self.showAlertForFinishing()
            }
        }
    }
    
    func showAlertForFinishing(){
        
        let alertController = UIAlertController(title: "Alarm", message: time , preferredStyle: .alert)
        
        //let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let defaultAction = UIAlertAction(title: "Ok", style: .default) { [unowned self] action in
            
            self.audioPlayer.stop()
            self.timer.invalidate()

            self.repeatTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.startTimerAgain), userInfo: nil, repeats: true);
        }
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func startTimerAgain() {
        
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - View will apear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName : "ALARM")
        
        do{
            
            alarms = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
            
            print("counld not fetch. \(error), \(error.userInfo)")
        }
        alarmsTableView .reloadData()

    }
   
    // MARK: - Table View methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if alarms.count > 0 {
            return alarms.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "cell"
        let cell : AlarmTableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! AlarmTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.timeLabel.font = UIFont.systemFont(ofSize: 20)
        cell.timeLabel.font = UIFont.boldSystemFont(ofSize: 22)
        cell.cellDelegate = self
        cell.checkAlarmOutlet.tag = indexPath.row
        print(cell.tag)
        print(indexPath.row)
        
        if  alarms.count > 0  {
            let alarmSTring = alarms[indexPath.row]
            
            //cell.taskLabel.text = taskSTring.value(forKey: "task") as? String
            cell.timeLabel.text = alarmSTring.value(forKey: "time") as? String
            cell.daysLabel.text = alarmSTring.value(forKey: "repeat") as? String

        } else {
            cell.daysLabel.text = ""
            cell.timeLabel.text = ""
            //cell.editButton.isUserInteractionEnabled = false
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let AlarmDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "AlarmDetailsViewController") as! AlarmDetailsViewController
        AlarmDetailsViewController.indexPathFromVC = indexPath.row
        AlarmDetailsViewController.actionFlag = "100"
        
        self.navigationController?.pushViewController(AlarmDetailsViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = alarms[indexPath.row]
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(alarm)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName : "ALARM")
            do {
                alarms = try managedContext.fetch(fetchRequest)
            } catch {
                print("Fetching Failed")
            }
        }
        alarmsTableView.reloadData()
    }
    
    func didPressButton(_ tag: NSInteger) {
        print("I have pressed a button with a tag: \(tag)")

        print(tag)
    }
    
    @IBAction func addAlarmAction(_ sender: AnyObject) {
        
        let AlarmDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "AlarmDetailsViewController") as! AlarmDetailsViewController
        
        self.navigationController?.pushViewController(AlarmDetailsViewController, animated: true)
        
    }

}

