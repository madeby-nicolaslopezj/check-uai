//
//  TeacherLoginViewController.swift
//  check-uai
//
//  Created by Nicolás López on 30-11-15.
//  Copyright © 2015 Nicolás López. All rights reserved.
//

import UIKit

class TeacherLoginViewController: UIViewController {

    @IBOutlet weak var teacherEmail: UITextField!
    @IBOutlet weak var teacherPassword: UITextField!
    @IBOutlet weak var colaboratorRut: UITextField!
    
    var sessions = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didClickTeacherButton(sender: AnyObject) {

        UAI.loginTeacher(self.teacherEmail.text!, password: self.teacherPassword.text!) { (error: UAIApiError?, token: String?) in
            if let err = error {
                print(err.describe())
            } else {
                currentTeacherToken = token!
                
                UAI.getTeacherSessions(currentTeacherToken, academicUnit: 1) { (error: UAIApiError?, sessions: NSArray?) in
                    if let err = error {
                        print(err.describe())
                    } else {
                        self.sessions = sessions!
                        self.performSegueWithIdentifier("showTeacherSessions", sender: self)
                    }
                }
            }
        }
    }

    @IBAction func didClickColaboratorButton(sender: AnyObject) {
        
        UAI.loginColaborator(self.colaboratorRut.text!){ (error: UAIApiError?, token: String?) in
            if let err = error {
                print(err.describe())
            } else {
                
            }
        }

    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showTeacherSessions" {
            let destinationViewController = segue.destinationViewController as! TeacherSessionsIndexViewController
            destinationViewController.sessions = self.sessions
        }
    }

}
