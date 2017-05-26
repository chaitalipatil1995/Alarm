//
//  AlarmDetailsViewController.swift
//  SWAlarm
//
//  Created by Amesten Systems on 25/05/17.
//  Copyright © 2017 Amesten Systems. All rights reserved.
//

import UIKit
import CoreData
class AlarmDetailsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    
    
    var alarmSetArray :NSArray = []
    var repeatDaysArray :NSArray = []
    var ringtoneArray :NSArray = []

    var dateString = NSString()
    var selectedDayString = NSString()
    var selectedRingtoneString = NSString()
    
    var alarms : [NSManagedObject] = []
    
    @IBOutlet var ringtoneView: UIView!

    @IBOutlet var ringtoneTableView: UITableView!
    @IBOutlet var repeatDaysTableView: UITableView!
    @IBOutlet var repeatView: UIView!
    @IBOutlet var timePickerDoneOutlet: UIButton!
    @IBOutlet var timePickerOutlet: UIDatePicker!
    @IBOutlet var setTimePickerView: UIView!
    @IBOutlet var detailSettingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailSettingTableView.backgroundColor = UIColor.clear
        repeatDaysTableView.backgroundColor = UIColor.clear
        ringtoneTableView.backgroundColor = UIColor.clear

        self.automaticallyAdjustsScrollViewInsets = false
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.view.backgroundColor = UIColor.black
        
        timePickerDoneOutlet.layer.borderColor = UIColor.white.cgColor
        timePickerDoneOutlet.layer.borderWidth = 1
        
        timePickerOutlet.setValue(UIColor.white, forKeyPath: "textColor")
      
        setTimePickerView.isHidden = true
        repeatView.isHidden = true
        ringtoneView.isHidden = true
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let result = formatter.string(from: date)

        dateString = result as NSString
        
        selectedDayString = "Never"
        
        selectedRingtoneString = "ncs_spectre"
        
        print(result)
        
        self.setTimePickerView.addSubview(timePickerOutlet)
        self.ringtoneView.addSubview(ringtoneTableView)
        
        alarmSetArray = ["Turn alarm on", "Time", "Repeat", "Ringtone", "Vibrate"]
        repeatDaysArray = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        ringtoneArray = ["ncs_spectre", "my_heart_ncs", "drag_me_down_nc", "alan_walker_fade", "heart_touching_music"]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    // MARK: - Table view Actions

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == detailSettingTableView {
            if alarmSetArray.count > 0 {
                return alarmSetArray.count
            } else {
                return 1
            }
        }
        
        if tableView == repeatDaysTableView {
            return repeatDaysArray.count
        }
        
        if tableView == ringtoneTableView {
            return ringtoneArray.count
        }
      return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == repeatDaysTableView {
            //repeatDaysCell
            let identifier = "repeatDaysCell"
            let cell : RepeatDaysTableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! RepeatDaysTableViewCell
            
            cell.dayLabel.text = repeatDaysArray[indexPath.row] as? String
            cell.backgroundColor = UIColor.clear
            return cell
            
        }
        if tableView == ringtoneTableView {
            let identifier = "RingtoneCell"
            let cell : RingtoneTableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! RingtoneTableViewCell
            
            cell.ringtoneLabel.text = ringtoneArray[indexPath.row] as? String
            cell.backgroundColor = UIColor.clear
            return cell
        }
        
        else {
        //tableView == detailSettingTableView {
            let identifier = "detailcell"
            let cell : AlarmDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! AlarmDetailTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.titleLabel.font = UIFont.systemFont(ofSize: 20)
            cell.titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
            // cell.cellDelegate = self
            // cell.editButton.tag = indexPath.row
            print(cell.tag)
            print(indexPath.row)
            
            let alarmSTring = alarmSetArray[indexPath.row]
            //cell.taskLabel.text = taskSTring.value(forKey: "task") as? String
            cell.titleLabel.text = alarmSTring as? String
            if indexPath.row == 0 {
                cell.subTitleLabel.isHidden = true
            }
            
            if indexPath.row == 1 {
                //  timePickerOutlet.isHidden = false
                cell.subTitleLabel.text = dateString as String
            }
            if indexPath.row == 2 {

                cell.subTitleLabel.text = selectedDayString as String
            }
            if indexPath.row == 3 {
                cell.subTitleLabel.text = selectedRingtoneString as String
            }
            
            if indexPath.row == 4 {
                cell.subTitleLabel.isHidden = true
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if tableView == detailSettingTableView {
            if indexPath.row == 1 {
                
                setTimePickerView.isHidden = false
                
            }
            if indexPath.row == 2 {
                repeatView.isHidden = false
            }
            
            if indexPath.row == 3 {
                ringtoneView.isHidden = false
            }
        }
        if tableView == repeatDaysTableView {

            selectedDayString = (repeatDaysArray[indexPath.row] as? NSString)!
            print(selectedDayString)
        }
        if tableView == ringtoneTableView {
            selectedRingtoneString = (ringtoneArray[indexPath.row] as? NSString)!
        }
        
        
    }
    
    
    // MARK: - Done i.e save Actions
    
    @IBAction func doneAction(_ sender: AnyObject) {
        
        // 1. dateString
        // 2. selectedDayString
        // 3. selectedRingtoneString
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ALARM", in: managedContext)!
        let alarm = NSManagedObject(entity: entity, insertInto: managedContext)
        alarm.setValue(dateString, forKey: "time")
        alarm.setValue(selectedDayString, forKey: "repeat")
        alarm.setValue(selectedRingtoneString, forKey: "ringtone")

        do{
            try managedContext.save()
            self.alarms.append(alarm)
            self.viewWillAppear(true)
        } catch let error as NSError {
            print("counld not save. \(error), \(error.userInfo)")
        }

        
        
        
        _ = navigationController?.popViewController(animated: true)
        
        // dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Delete Actions

    @IBAction func delectAction(_ sender: AnyObject) {
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    // MARK: - Picker Actions
    @IBAction func pickerDoneAction(_ sender: AnyObject) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let strDate = dateFormatter.string(from: timePickerOutlet.date)
        dateString = strDate as NSString
        print(dateString )
        //self.updateName(index: indexPath, newName: dateString as String)
        self.viewWillAppear(true)
        setTimePickerView.isHidden = true
        
        detailSettingTableView.reloadData()
        
    }
    
    // MARK: - Repeat alarm day
    
    @IBOutlet var repeatOKOutlet: UIButton!
    @IBAction func repeatOKAction(_ sender: AnyObject) {
        detailSettingTableView.reloadData()
        repeatView.isHidden = true
    }
    
    @IBOutlet var repeatCancelOutlet: UIButton!
    @IBAction func repeatCancelAction(_ sender: AnyObject) {
        repeatView.isHidden = true
    }
    
    
    // MARK: - Ringtone set
    
    @IBOutlet var ringtoneCancelOutlet: UIButton!
    @IBAction func ringtoneCancelAction(_ sender: AnyObject) {
        ringtoneView.isHidden = true

    }
    @IBOutlet var ringtoneOKOutlet: UIButton!
    @IBAction func ringtoneOKAction(_ sender: AnyObject) {
        
        detailSettingTableView.reloadData()
        ringtoneView.isHidden = true

    }
    
    

}
