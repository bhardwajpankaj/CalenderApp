//
//  HomeTableViewCell.swift
//  Calendar
//
//  Test Project
//

import UIKit

protocol PopulateCell {
    func populateCell(viewModel: LoadCellData)
}

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var customer: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var tasks: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var timeRequired: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 10.0
        self.statusView.layer.cornerRadius = self.status.frame.height / 2.0
        self.statusView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
}

extension HomeTableViewCell: PopulateCell {
    
    //MARK:- Set data on UILabels
    func populateCell(viewModel: LoadCellData) {
        self.customer.text = viewModel.customerName
        self.status.text = viewModel.status
        self.tasks.text = viewModel.task
        self.arrivalTime.text = viewModel.arrivalTime
        self.destination.text = viewModel.destination
        self.timeRequired.text = viewModel.timeRequired
        self.distance.text = viewModel.distance
        self.statusView.backgroundColor = statusColor(visitState: viewModel.status )
    }
}

extension HomeTableViewCell {
    
    //MARK:- Get Status color
    private func statusColor(visitState:String) -> UIColor{
        switch visitState {
        case StatusColor.done.rawValue:
            return .doneOption
        case StatusColor.inProgress.rawValue:
            return .inProgressOption
        case StatusColor.todo.rawValue:
            return .todoOption
        case StatusColor.rejected.rawValue:
            return .rejectedOption
        default:
            return .doneOption
        }
    }
}
