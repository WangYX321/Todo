//
//  CalendarViewController.swift
//  Todo
//
//  Created by wyx on 2017/8/20.
//  Copyright © 2017年 wyx. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var _date = Date()
    var date: Date {
        get {
            return _date
        }
        set(value) {
            _date = value
            self.title = "\(self.year(date: _date))-\(self.month(date: _date))"
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let weekArr = ["Sun", "Mon", "Tue", "Wes", "Thu", "Fri", "Sat"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib. 
        collectionView.delegate = self
        collectionView.dataSource = self;
        
        let swipeNext = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesAction(ges:)))
        swipeNext.direction = .left
        self.collectionView.addGestureRecognizer(swipeNext)
        
        let swipePrevious = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesAction(ges:)))
        swipePrevious.direction = .right
        self.collectionView.addGestureRecognizer(swipePrevious)
        
        self.title = "\(self.year(date: _date))-\(self.month(date: _date))"
    }
    
    func swipeGesAction(ges:UISwipeGestureRecognizer) {
        if ges.direction == .left {
            UIView.transition(with: self.view, duration: 0.5, options: .transitionCurlUp, animations: { 
                self.date = self.nextMonth(date: self._date)
                self.collectionView.reloadData()
            }, completion: nil)
        }
        if ges.direction == .right {
            UIView.transition(with: self.view, duration: 0.5, options: .transitionCurlDown, animations: { 
                self.date = self.lastMonth(date: self._date)
                self.collectionView.reloadData()
            }, completion: nil)
        }
    }

    // MARK: 代理
    //每个区的item个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 7
        } else {
            return 42
        }
    }
    
    //分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    //自定义cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekCellId", for: indexPath) as! WeekCell
            cell.titleLabel.text = weekArr[indexPath.row]
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumCellId", for: indexPath) as! CalendarCell
            
            let daysInMonth = self.totalDaysInMonth(date: _date)
            let firstWeekDay = self.firstWeekInThisMonth(date: _date)
            var day = 0
            let i = indexPath.row
            let today = Date()
            if i < firstWeekDay {
                cell.titleLabel.text = ""
            } else if (i > firstWeekDay + daysInMonth - 1) {
                cell.titleLabel.text = ""
            } else {
                day = i - firstWeekDay + 1
                cell.titleLabel.text = "\(day)"
                cell.titleLabel.textColor = UIColor.black
                
                if Calendar.current.isDateInToday(_date) {
                    if day == self.day(date: _date) {
                        cell.titleLabel.textColor = UIColor.blue
                    } else if day > self.day(date: _date) {
                        cell.titleLabel.textColor = UIColor.lightGray
                    }
                } else if (today.compare(_date) == .orderedAscending) {
                    cell.titleLabel.textColor = UIColor.lightGray
                }
            }
            
//            cell.titleLabel.text = "\(indexPath.row)"
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: self.view.bounds.size.width/7, height: self.view.bounds.size.width/7)
        } else {
            return CGSize(width: self.view.bounds.size.width/7, height: (self.view.bounds.size.height-self.view.bounds.size.width/7 - 64)/6)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func day(date:Date) -> Int {
        let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return component.day!
    }
    
    func month(date:Date) -> Int {
        let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return component.month!
    }
    
    func year(date:Date) -> Int {
        let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return component.year!
    }

    func firstWeekInThisMonth(date:Date) -> Int {
        var calendar = Calendar.current
        calendar.firstWeekday = 1   //当前日历以星期日为一周的起始
        var components = calendar.dateComponents([.year, .month, .day], from: date) //通过date获取dateComponents
        components.day = 1  //将dateComponents设置为月份第一天
        
        var weekday: Int = 1
        if let firstDayOfMonthDate = calendar.date(from: components) {
            if let firstWeekDay = calendar.ordinality(of: .weekday, in: .weekOfMonth, for: firstDayOfMonthDate) {
                weekday = firstWeekDay - 1
            }
        }
        
        return weekday
    }
    
    func totalDaysInMonth(date: Date) -> Int {
        let calendar = Calendar.current
        var daysInMonth: Int = 0
        if let days = calendar.range(of: .day, in: .month, for: date) {
            daysInMonth = days.count
        }
        return daysInMonth
    }

    func lastMonth(date:Date) -> Date {
        var dateComponent = DateComponents()
        dateComponent.month = -1
        let newDate = Calendar.current.date(byAdding: dateComponent, to: date, wrappingComponents: false)
        return newDate!
    }
    
    func nextMonth(date:Date) -> Date {
        var dateComponent = DateComponents()
        dateComponent.month = +1
        let newDate = Calendar.current.date(byAdding: dateComponent, to: date, wrappingComponents: false)
        return newDate!
    }
}

