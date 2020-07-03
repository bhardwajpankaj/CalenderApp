//
//  ViewController.swift
//  Calendar
//
//  Test Project
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, AlertDisplayer {
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var calendarView: UIView!
    @IBOutlet weak var calendar: UIView!
    @IBOutlet weak var calendarButton: UIBarButtonItem!
    @IBOutlet weak var workOrderTableView: UITableView!
    @IBOutlet weak var calendarViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var workOrderTableViewTopConstraint : NSLayoutConstraint!
    let refreshControl = UIRefreshControl()
    var activityView : UIActivityIndicatorView! = nil
    private let cellID = "HomeTableViewCell"
    var viewModel:CleanerListViewModel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCalendar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.initialSetup()
        self.showActivityIndicatory()
        self.fetchCarWashVisitList()
        self.addingTapGesture()
    }
    
    //MARK:- UI setups
    private func setupUI() {
        self.navBar.transparentNavigationBar()
        let nib = UINib(nibName: self.cellID, bundle: nil)
        self.workOrderTableView.register(nib, forCellReuseIdentifier: self.cellID)
        self.workOrderTableView.rowHeight = UITableView.automaticDimension
        self.workOrderTableView.estimatedRowHeight = 170
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        workOrderTableView.addSubview(refreshControl)
    }
    
    //MARK:- Initial Setup
    private func initialSetup()
    {
        viewModel = CleanerListViewModel()
        let keyDateFormatter = DateFormatter()
        keyDateFormatter.dateFormat = "yyyy-MM-dd"
        viewModel.selectedDate = keyDateFormatter.string(from: Date())

        self.navBar.topItem?.title = "I DAG"
        calendarViewHeightConstraint.constant = 0
        workOrderTableViewTopConstraint.constant = 20
    }
    
    //MARK:- Adding Tap gesture
    private func addingTapGesture()
    {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.hideCalender(sender:)))
        self.workOrderTableView.addGestureRecognizer(gesture)
    }
    
    //MARK:- Get Cleaner list
    private func fetchCarWashVisitList(){
        
        self.viewModel.dictOfVisitModelArray.bind { [weak self] (dataSource) in
            if let self = self {
                self.workOrderTableView.reloadData()
            }
        }
        
        self.viewModel.loadCarWashVisitList{ (error) in
            DispatchQueue.main.async {
                self.activityView.stopAnimating()
            }
        }
    }
    
    //MARK:- Refresh data
    @objc func refresh(_ sender: AnyObject) {
        self.viewModel.loadCarWashVisitList { (error) in
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    
    //MARK:- Add calender to view
    private func addCalendar() {
        if let calendar = CalendarView.addCalendar(self.calendar) {
            calendar.delegate = self
        }
    }
    
    //MARK:- Show calendar when tapped, Hide the calendar when tapped outside the calendar view
    @IBAction func calendarTapped(_ sender: UIBarButtonItem) {
        calendarViewHeightConstraint.constant = 200
        workOrderTableViewTopConstraint.constant = 140
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK:- Handle Canlendar hide
    @objc func hideCalender(sender : UITapGestureRecognizer) {
        calendarViewHeightConstraint.constant = 0
        workOrderTableViewTopConstraint.constant = 20
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK:- Set NavBar Title
    private func setNavBarTitle(_ date: String) {
        let formatter = DateFormatter()
        let todayDate = Date()
        formatter.dateFormat = "yyyy-MM-dd"
        if(date == formatter.string(from: todayDate)){
            self.navBar.topItem?.title = "I DAG"
        }else {
            self.navBar.topItem?.title = date
        }
    }
    
    //MARK:- Activity Indicator while loading
    private func showActivityIndicatory() {
        activityView = UIActivityIndicatorView(style: .large)
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.startAnimating()
    }
    
}


//MARK:- Tableview delegate and datasource methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as? PopulateCell
        if let cellData =  self.viewModel.getCarWashVisitViewModel(_at: indexPath.row) {
            cell?.populateCell(viewModel: cellData)
        }
        return cell as! UITableViewCell
    }
}

//MARK:- Get selected calendar date
extension HomeViewController: CalendarDelegate {
    
    func getSelectedDate(_ date: String) {
        self.setNavBarTitle(date)
        self.viewModel.selectedDate = date
        self.workOrderTableView.reloadData()
    }
    
}
