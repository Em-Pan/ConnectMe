//
//  SwipingViewController.swift
//  ParseStarterProject
//
//  Created by Mau Pan on 10/20/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class SwipingViewController: UIViewController {

    @IBOutlet var currentUserImage: UIImageView!
    
    @IBOutlet var lookingFor: UILabel!
    
    @IBOutlet var hiringUserLabel: UILabel!
    
    var displayedUserId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUser = currentUserImage
        
        self.view.addSubview(currentUser)
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        currentUser.addGestureRecognizer(gesture)
        
        currentUser.userInteractionEnabled = true
        
        updateSelectedUser()
        
        
        
    }

    func wasDragged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translationInView(self.view)
        let label = gesture.view!
        
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y - 100)
        
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        var scale = min(150 / abs(xFromCenter), 1)
        
        var rotation = CGAffineTransformMakeRotation(xFromCenter / 200)
        
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        
        label.transform = stretch
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            var acceptedOrRejected = ""
            
            if label.center.x < 100 {
                
                acceptedOrRejected = "rejected"
                
            } else if label.center.x > self.view.bounds.width - 100 {
                
                acceptedOrRejected = "accepted"
                
            }
            if acceptedOrRejected != "" {
                
                PFUser.currentUser()?.addUniqueObjectsFromArray([displayedUserId], forKey:acceptedOrRejected)

                PFUser.currentUser()?.save()
                updateSelectedUser()
                
            }

            
            rotation = CGAffineTransformMakeRotation(0)
            
            stretch = CGAffineTransformScale(rotation, 1, 1)
            
            label.transform = stretch
            
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2 - 100)
            
        }

        
    }
    
    func updateSelectedUser() {

        let query = PFUser.query()
        
        let lookingTo = !(PFUser.currentUser()?["lookingToWork"] as! Bool)
        
        print(lookingTo)
        var ignoredUsers = [""]
        
        if let acceptedUsers = PFUser.currentUser()?["accepted"] {
            ignoredUsers += acceptedUsers as! Array
        }
        
        if let rejectedUsers = PFUser.currentUser()?["rejected"] {
            ignoredUsers += rejectedUsers as! Array
        }
        query!.whereKey("objectId", notContainedIn: ignoredUsers)

        
        query!.whereKey("lookingToWork", equalTo:lookingTo)
        query!.limit = 1
        
        query?.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error != nil {
                
                print(error)
                
            } else if let objects = objects as? [PFObject] {
                
                for object in objects {
                    
                    self.displayedUserId = object.objectId!
                    
                    let imageFile = object["image"] as! PFFile
                    if let name = self.hiringUserLabel {
                        
                        name.text = (object["name"] as! String)
                    }
                    
                    if let lookingFor = self.lookingFor {
                        
                        lookingFor.text = (object["lookingFor"] as! String)
                    }
                    
                    imageFile.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        
                        if error != nil {
                            
                            print(error)
                            
                        } else {
                            
                            if let data = imageData {
                                
                                self.currentUserImage.image = UIImage(data: data)
                                
                            }
                            
                        }
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "logOut" {
            
            PFUser.logOut()
            
        }
        
        
    }
}
