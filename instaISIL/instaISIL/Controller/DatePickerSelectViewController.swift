//
//  DatePickerSelectViewController.swift
//  InstaISIL
//
//  Created by Kaori on 10/8/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit


protocol DatePickerSelectViewControllerDelegate: PickerOptionViewControllerDelegate {
    
    func datePickerSelectViewController(_ controller: DatePickerSelectViewController, didSelectDate date: Date)
}

class DatePickerSelectViewController: PickerOptionViewController {
    
    var dateDelegate: DatePickerSelectViewControllerDelegate? {
        get { return delegate as? DatePickerSelectViewControllerDelegate }
        set { delegate = newValue }
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func changeDateSelect(_ datePicker: UIDatePicker) {
        print(datePicker.date)
        self.dateDelegate?.datePickerSelectViewController(self, didSelectDate: datePicker.date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let currentDate: String = dateFormatter.string(from: Date())
        let currentDateFormatted = dateFormatter.date(from: currentDate)
        
        self.datePicker.date = currentDateFormatted!
        self.view.backgroundColor = .clear
        self.pickerViewContent.transform = CGAffineTransform(translationX: 0, y: self.pickerViewContent.frame.height)
    }

}
