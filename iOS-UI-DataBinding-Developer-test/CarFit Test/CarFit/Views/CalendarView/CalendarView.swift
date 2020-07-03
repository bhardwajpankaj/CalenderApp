//
//  CalendarView.swift
//  Calendar
//
//  Test Project
//

import UIKit

protocol CalendarDelegate: class {
    func getSelectedDate(_ date: String)
}

class CalendarView: UIView {
    
    @IBOutlet weak var monthAndYear: UILabel!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    private let cellID = "DayCell"
    weak var delegate: CalendarDelegate?
    var viewModel = CalendarViewModel.instance()
    
    //MARK:- Initialize calendar
    private func initialize() {
        let nib = UINib(nibName: self.cellID, bundle: nil)
        self.daysCollectionView.register(nib, forCellWithReuseIdentifier: self.cellID)
        self.daysCollectionView.delegate = self
        self.daysCollectionView.dataSource = self
        self.daysCollectionView.allowsMultipleSelection = false
        self.rightBtn.tag = 1
        initialSetupOfCalender()
    }
    
    //MARK:- Initial Setup
    private func initialSetupOfCalender()
    {
        monthAndYear.text = viewModel.monthAndYear
        if let currentDay = Int(self.viewModel.getCurrentDay()){
            updateCellSelectionOnDay(day: currentDay)
        }
    }
    
    private func updateCellSelectionOnDay(day:Int){
        // Below code is to select day initially
        DispatchQueue.main.async {
                self.daysCollectionView.selectItem(at: IndexPath(item: day - 1, section: 0), animated: true, scrollPosition: .bottom)
                self.collectionView(self.daysCollectionView, didSelectItemAt: IndexPath(item: day - 1, section: 0))
        }
    }
    
    //MARK:- Change month when left and right arrow button tapped
    @IBAction func arrowTapped(_ sender: UIButton) {
        monthAndYear.text = viewModel.nextAndPreviousButtonAction(senderTag: sender.tag)
        viewModel.formatter.dateFormat = "MMM yyyy"
        let currentMonthStr = viewModel.formatter.string(from: Date())

        if(currentMonthStr == viewModel.monthAndYear) {
            updateCellSelectionOnDay(day:1)
        }
        self.daysCollectionView.reloadData()
        self.daysCollectionView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
    }
}

//MARK:- Calendar collection view delegate and datasource methods
extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getCurrentMonthDays()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as? DayCell
        cell?.populateCell(viewModel: viewModel.getCalenderDayModel(_at: indexPath.row))
        if cell?.isSelected ?? false {
            cell?.dayView.backgroundColor = .daySelected
        }else{
            cell?.dayView.backgroundColor = .clear
        }
        return cell ?? UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? DayCell
        cell?.dayView.backgroundColor = .daySelected
        self.delegate?.getSelectedDate(viewModel.getSelectedDate(day: "\(indexPath.row + 1)", monthAndYear: self.monthAndYear.text ?? ""))
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? DayCell
        cell?.dayView.backgroundColor = .clear
    }
}

//MARK:- Add calendar to the view
extension CalendarView {
    
    public class func addCalendar(_ superView: UIView) -> CalendarView? {
        var calendarView: CalendarView?
        if calendarView == nil {
            calendarView = UINib(nibName: "CalendarView", bundle: nil).instantiate(withOwner: self, options: nil).last as? CalendarView
            guard let calenderView = calendarView else { return nil }
            calendarView?.frame = CGRect(x: 0, y: 0, width: superView.bounds.size.width, height: superView.bounds.size.height)
            superView.addSubview(calenderView)
            calenderView.initialize()
            return calenderView
        }
        return nil
    }
    
}
