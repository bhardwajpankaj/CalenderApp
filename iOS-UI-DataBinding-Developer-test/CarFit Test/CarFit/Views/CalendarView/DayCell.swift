//
//  DayCell.swift
//  Calendar
//
//  Test Project
//

import UIKit

protocol PopulateDayCell {
    func populateCell(viewModel: CalenderDayModel)
}

class DayCell: UICollectionViewCell {

    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var weekday: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dayView.layer.cornerRadius = self.dayView.frame.width / 2.0
        self.dayView.backgroundColor = .clear
    }
}

//MARK:- Populate Cell data on UI
extension DayCell : PopulateDayCell {
    func populateCell(viewModel: CalenderDayModel) {
        self.day.text = viewModel.day
        self.weekday.text = viewModel.weekDay
    }
}
