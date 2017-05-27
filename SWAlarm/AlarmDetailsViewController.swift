//
//  AlarmDetailsViewController.swift
//  SWAlarm
//
//  Created by Amesten Systems on 25/05/17.
//  Copyright © 2017 Amesten Systems. All rights reserved.
//

import UIKit
import CoreData
class AlarmDetailsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, cellDelegateProtocol {

    
    
    var alarmSetArray :NSArray = []
    var repeatDaysArray :NSArray = []
    var ringtoneArray :NSArray = []

    var indexPathFromVC = Int()
    var actionFlag = NSString()
    
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
    
    //MARK: - View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailSettingTableView.backgroundColor = UIColor.clear
        repeatDaysTableView.backgroundColor = UIColor.clear
        ringtoneTableView.backgroundColor = UIColor.clear
        detailSettingTableView.backgroundColor = UIColor.black
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
        
        
        
        self.setTimePickerView.addSubview(timePickerOutlet)
        self.ringtoneView.addSubview(ringtoneTableView)
        
        alarmSetArray = ["Turn alarm on", "Time", "Repeat", "Ringtone", "Vibrate"]
        repeatDaysArray = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        ringtoneArray = ["ncs_spectre", "my_heart_ncs", "drag_me_down_nc", "alan_walker_fade", "heart_touching_music"]
        
        // Do any additional setup after loading the view.
    }

    //MARK: - View Will Apear
    
    override func viewWillAppear(_ animated: Bool) {
        
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

        print(indexPathFromVC)
        
        if actionFlag == "100" {
            
            let alarmSTring = alarms[indexPathFromVC]
            
            dateString = alarmSTring.value(forKey: "time") as! NSString
            selectedDayString = alarmSTring.value(forKey: "repeat") as! NSString
            selectedRingtoneString = alarmSTring.value(forKey: "ringtone") as! NSString
            
        } else {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            let result = formatter.string(from: date)
            
            print(result)
            dateString = result as NSString
            
            selectedDayString = "Never"
            
            selectedRingtoneString = "ncs_spectre"
        }

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
            
            cell.cellDelegate = self
            cell.onButtonOutlet.tag = indexPath.row
            
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
                cell.onButtonOutlet.isHidden = true
            }
            if indexPath.row == 2 {

                cell.subTitleLabel.text = selectedDayString as String
                cell.onButtonOutlet.isHidden = true

            }
            if indexPath.row == 3 {
                cell.subTitleLabel.text = selectedRingtoneString as String
                cell.onButtonOutlet.isHidden = true

            }
            
            if indexPath.row == 4 {
                cell.subTitleLabel.isHidden = true
            }
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if tableView == detailSettingTableView {
            
            if indexPath.row == 0 {
                setTimePickerView.isHidden = true
                repeatView.isHidden = true
                ringtoneView.isHidden = true
            }
            
            if indexPath.row == 1 {
                setTimePickerView.isHidden = false
                repeatView.isHidden = true
                ringtoneView.isHidden = true
            }
            if indexPath.row == 2 {
                repeatView.isHidden = false
                ringtoneView.isHidden = true
                setTimePickerView.isHidden = true

            }
            
            if indexPath.row == 3 {
                ringtoneView.isHidden = false
                setTimePickerView.isHidden = true
                repeatView.isHidden = true

            }
            
            if indexPath.row == 4 {
                setTimePickerView.isHidden = true
                repeatView.isHidden = true
                ringtoneView.isHidden = true
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
    
    
 
    
    
    //MARK: - protocol method
    
    func didPressButton(_ tag: NSInteger) {
        print("I have pressed a button with a tag: \(tag)")
        
        print(tag)
    }
    
    // MARK: - Done i.e save Actions
    
    @IBAction func doneAction(_ sender: AnyObject) {
        
        // 1. dateString
        // 2. selectedDayString
        // 3. selectedRingtoneString
        
        if actionFlag == "100" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            alarms[indexPathFromVC] .setValue(dateString, forKey: "time")
            alarms[indexPathFromVC] .setValue(selectedDayString, forKey: "repeat")
            alarms[indexPathFromVC] .setValue(selectedRingtoneString, forKey: "ringtone")

            appDelegate.saveContext()
        } else {
            
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
               // self.viewWillAppear(true)
            } catch let error as NSError {
                print("counld not save. \(error), \(error.userInfo)")
            }
        
        }
        
        _ = navigationController?.popViewController(animated: true)
        
        // dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Delete Actions

    @IBAction func delectAction(_ sender: AnyObject) {
        if actionFlag == "100" {
            
            self.showAlertForDeleting()
            
        } else {
            _ = navigationController?.popViewController(animated: true)

        }
        
    }
    func showAlertForDeleting(){
        
        let alertController = UIAlertController(title: "Delete alarm", message: "Delete this alarm?" , preferredStyle: .alert)
        
        //let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let defaultAction = UIAlertAction(title: "Ok", style: .default) { [unowned self] action in

            let alarmStrings = self.alarms[self.indexPathFromVC]
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(alarmStrings)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName : "ALARM")
            do {
                self.alarms = try managedContext.fetch(fetchRequest)
            } catch {
                print("Fetching Failed")
            }
            
            _ = self.navigationController?.popViewController(animated: true)

        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
        
    }

    
    // MARK: - Picker Actions
    @IBAction func pickerDoneAction(_ sender: AnyObject) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let strDate = dateFormatter.string(from: timePickerOutlet.date)
        dateString = strDate as NSString
        print(dateString )
        //self.updateName(index: indexPath, newName: dateString as String)
        //self.viewWillAppear(true)
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
