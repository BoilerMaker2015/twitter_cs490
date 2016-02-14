//
//  TwitterClient.swift
//  
//
//  Created by wentai,cui on 2/6/16.
//
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "CVRmxjPLw3uAwQMDDH8apgjyJ"
let twitterConsumerSecret = "MYtI6WsqIicGUuPcLFhnKx4bWkRCPR5LgVeHoffZKJc8OEaKRg"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {

    
    var loginCompletion: ((user: User?, error: NSError?) -> (Void))?
    
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey:  twitterConsumerKey, consumerSecret:  twitterConsumerSecret)
        }
        return Static.instance
    }
    
    
    func timeLineWithCompletion(parameters: NSDictionary? ,completion: (tweets: [Tweet]?, error: NSError?) -> Void) {
        
        
        GET("1.1/statuses/home_timeline.json", parameters: parameters, progress: { (progress: NSProgress) -> Void in
            
            }, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                //print(response)
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error)
                completion(tweets: nil, error: error)
        })
    }
    
    func my_log(webview: UIWebView ,completion: (user: User?, error: NSError?) -> Void) {
        loginCompletion = completion
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "t4c://oauth"), scope: nil, success: { (requestToken) -> Void in
            
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
            webview.loadRequest(NSURLRequest(URL: authURL!))
            
            }) { (error) -> Void in
                self.loginCompletion?(user: nil, error: error)
                
        }
    }
    
    
    
    func Login_with(completion: (user: User?, error: NSError?) -> Void) {
        loginCompletion = completion
        
        
        
        //fetch request token
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "t4c://oauth"), scope: nil, success: { (requestToken) -> Void in
            
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
            UIApplication.sharedApplication().openURL(authURL!)
            
            }) { (error) -> Void in
                self.loginCompletion?(user: nil, error: error)
                
        }
    }
    
    
    func like(withID id:NSNumber, complete: (response: NSDictionary?, error: NSError?) -> Void) {
        let parameter: NSDictionary = ["id": id]
        POST("1.1/favorites/create.json", parameters: parameter, progress: { (progress) -> Void in
            
            }, success: { (task, response) -> Void in
                complete(response: response as? NSDictionary, error: nil)
            }) { (task, error) -> Void in
                complete(response: nil, error: error)
                print("retweet")
                
        }
    }
    
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // fectch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwittermatthewpage://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            print("https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                print("Failed to get request token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got the access token!")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                //    print("user: \(response)")
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                print("user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                    print("Error getting current user")
                    self.loginCompletion?(user: nil, error: error)
            })
            
            
            }) { (error: NSError!) -> Void in
                print("Failed to rceieve access token")
                self.loginCompletion?(user: nil, error: error)
                
        }

        
        

    }
}
