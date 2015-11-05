//
//  SignUpViewController.swift
//  ParseStarterProject
//
//  Created by Mau Pan on 10/18/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse


class SignUpViewController: UIViewController {

    @IBOutlet var userImage: UIImageView!
    
    @IBOutlet var lookingToWork: UISwitch!
    
    @IBOutlet var lookingFor: UITextField!
    
    @IBAction func signUp(sender: AnyObject) {
        
        PFUser.currentUser()?["lookingToWork"] = lookingToWork.on
        PFUser.currentUser()?.save()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        // Add test users for test swiping
        let urlArray = ["http://static2.businessinsider.com/image/539f3ffbeab8ea5a135f9f71-1200/lets-start-with-some-startups-hotel-tonights-logo-doubles-as-a-bed-and-an-h.jpg","http://static4.businessinsider.com/image/539f3ffceab8eab10f5f9f71-1200/we-like-jellys-logo-not-only-because-its-bright-and-recognizable-but-because-it-cleverly-doubles-as-a-jellyfish-and-a-brain.jpg","http://static3.businessinsider.com/image/53c94bdfeab8ea3701fc6d97-1200/pinterests-logo-often-seen-as-just-the-iconic-p-in-a-red-circle-captures-the-crafty-creative-vibe-of-its-users-plus-take-note-of-what-the-bottom-of-the-p-looks-like-.jpg","http://static1.businessinsider.com/image/53c959a76bb3f7a872b808b7-1200/the-adorable-logo-orbotix-uses-to-market-its-fast-paced-robots-sphero-and-ollie-fits-its-products-perfectly.jpg","http://static1.businessinsider.com/image/539f3ffceab8ea94125f9f75-1200/a-pen-and-paper-or-a-q-the-logo-of-the-collaborative-documents-company-quip-is-a-good-fit.jpg","http://static2.businessinsider.com/image/53c970c66da8110347e03a48-1200/now-that-snapchats-mascot-ghostface-chillah-has-lost-his-goofy-face-the-logo-is-a-cleaner-fit-for-the-disappearing-messages-app.jpg","http://static3.businessinsider.com/image/53c952126bb3f75e57b808b7-1200/squares-logo-proves-that-sometimes-simplicity-trumps-flashiness-this-is-a-gorgeous-clean-logo.jpg","http://static3.businessinsider.com/image/53c95b4b6bb3f7797ab808b7-1200/gett-a-black-car-service-similar-to-uber-has-an-effective-logo-because-it-evokes-the-traditional-taxi-cab-experience-while-offering-an-easier-though-more-expensive-option.jpg","http://static4.businessinsider.com/image/53c9621a6bb3f73813b808b7-1200/nests-app-store-logo-is-clever-because-the-door-of-the-house-doubles-as-the-companys-signature-n.jpg","http://static4.businessinsider.com/image/526e9c90eab8ea6035e65a0a-1200/soundclouds-logo-is-half-audio-waves-half-fluffy-cloud.jpg","http://static4.businessinsider.com/image/527d1f01ecad044e640cd41a-1200/ponchos-orange-feline-fits-the-startups-fun-and-silly-weather-updates-and-the-half-moon-calls-to-mind-an-umbrella.jpg","http://static3.businessinsider.com/image/526e9c8e6bb3f76c22e65a03-1200/an-elephant-never-forgets--and-evernote-will-help-you-keep-everything-you-need-to-remember-in-one-place.jpg","http://static4.businessinsider.com/image/53c9682ceab8ea606bfc6d9c-1200/slack-a-communications-platform-for-businesses-uses-a-pretty-multicolored-hashtag-as-its-logo.jpg"]
        
        var counter = 4
        
        for url in urlArray {
            let nsUrl = NSURL(string: url)!
            print(url)
            
            if let data = NSData(contentsOfURL: nsUrl) {
                
                self.userImage.image = UIImage(data: data)
                
                let imageFile:PFFile = PFFile(data: data)
                
                var user:PFUser = PFUser()
                
                var username = "user\(counter)"
                
                user.username = username
                
                user.password = "pass"
                
                user["image"] = imageFile
                user["lookingToWork"] = false
                
                counter++
                user.signUp()
                
            }
            
            
        }

        */
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name"])
        graphRequest.startWithCompletionHandler( {
            (connection, result, error) -> Void in
            
            if error != nil {
                print(error)
                
            } else if let result = result {
                
                print(result)
                PFUser.currentUser()?["name"] = result["name"]
                
                PFUser.currentUser()?.save()
                
                let userId = result["id"] as! String
                
                let facebookProfilePictureURL = "https://graph.facebook.com/" + userId + "/picture?type=large"
                
                if let facebookPicURL = NSURL(string: facebookProfilePictureURL) {
                    
                    if let data = NSData(contentsOfURL: facebookPicURL) {
                        
                        self.userImage.image = UIImage(data: data)
                        
                        let imageFile:PFFile = PFFile(data: data)
                        
                        PFUser.currentUser()?["image"] = imageFile
                        
                        PFUser.currentUser()?.save()
                        
                    }
                    
                }
                
            }
        })
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
