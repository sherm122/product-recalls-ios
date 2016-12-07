//
//  DetailController.swift
//  Product Recalls
//
//  Created by Adam Sherman on 12/6/16.
//  Copyright © 2016 Adam Sherman. All rights reserved.
//

import UIKit

class DetailController: UIViewController {

    var recall: Recall!
    
    @IBOutlet weak var date: UITextView!
    @IBOutlet weak var contact: UITextView!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var theTitle: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.theTitle.text = self.recall.theTitle
        self.contact.text = self.recall.theContact
        self.date.text = self.recall.recallDate
        self.desc.text = self.recall.theDescription
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
