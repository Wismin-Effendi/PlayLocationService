//
//  FirstViewController.swift
//  PlayLocationService
//
//  Created by Wismin Effendi on 8/21/17.
//  Copyright © 2017 iShinobi. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, TaskLocationDelegate {

    @IBOutlet weak var locationLabel: UILabel!
    
    var taskLocation: TaskLocation = TaskLocation() {
        didSet {
           locationLabel.text = taskLocation.title! + " - " + taskLocation.subtitle!
        }
    }
    
    var coreDataStack: CoreDataStack!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.LocationList {
            let vc = segue.destination as! LocationListViewController
            vc.coreDataStack = coreDataStack
            vc.delegate = self 
        }
    }
 

}
