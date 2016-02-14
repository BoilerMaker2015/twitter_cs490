//
//  TimelineViewController.swift
//  Twitter
//
//  Created by wentai,cui on 2/7/16.
//  Copyright © 2016 frostao. All rights reserved.
//

import UIKit
import SVPullToRefresh

class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: .ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        tableView.addInfiniteScrollingWithActionHandler { () -> Void in
            let lastTweet = self.tweets![self.tweets!.count-1]
            let lastID = lastTweet.id
            let parameters:NSDictionary = ["max_id": lastID!]
            TwitterClient.sharedInstance.timeLineWithCompletion(parameters, completion: { (tweets, error) -> Void in
                for tweet in tweets! {
                    self.tweets?.append(tweet)
                }
                self.tableView.reloadData()
                self.tableView.infiniteScrollingView.stopAnimating()
            })
            
            
            
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        TwitterClient.sharedInstance.timeLineWithCompletion(nil) { (tweets, error) -> Void in
            self.tweets = tweets
            self.tableView.reloadData()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.timeLineWithCompletion(nil) { (tweets, error) -> Void in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TweetsCell
        if let tweets = tweets {
            let tweet = tweets[indexPath.row]
            let user = tweet.user
            cell.tweet = tweet
            
                cell.likeButton.setBackgroundImage(UIImage(named: "like-action-pressed"), forState: .Normal)
        
            
            if tweet.retweeted! {
                cell.retweetButton.setBackgroundImage(UIImage(named: "retweet-action-pressed"), forState: .Normal)
            }

            cell.name.text = user?.name
            cell.username.text = "@\(user!.screenName!)"
            cell.profileImage.setImageWithURL(NSURL(string: user!.profileImageUrl!)!)
            cell.content.text = tweet.text
            let time = Int((tweet.createAt?.timeIntervalSinceNow)!)
            let hours = -time / 3600
            
            cell.time.text = "\(hours)h"
        }
        return cell
    }
    
    
    
    @IBAction func didClickLogout(sender: AnyObject) {
        User.currentUser?.logout()
        
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
