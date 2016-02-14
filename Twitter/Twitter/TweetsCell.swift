//
//  TweetsCell.swift
//  Twitter
//
//  Created by wentai,cui on 2/7/16.
//  Copyright © 2016 frostao. All rights reserved.
//

import UIKit

class TweetsCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var repostCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    
    var tweet: Tweet?
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func replyTapped(sender: AnyObject) {
    }
    @IBAction func retweetTapped(sender: AnyObject) {
        if tweet!.retweeted! {
            TwitterClient.sharedInstance.unretweet(withID: tweet!.id!, complete: { (response, error) -> Void in
                self.retweetButton.setBackgroundImage(UIImage(named: "retweet-action"), forState: .Normal)
                self.tweet?.repostCount = self.tweet!.repostCount!.integerValue - 1
                self.repostCount.text = self.tweet?.repostCount?.description
                self.tweet?.retweeted = false
                
            })
        } else {
            TwitterClient.sharedInstance.retweet(withID: tweet!.id!, complete: { (response, error) -> Void in
                self.retweetButton.setBackgroundImage(UIImage(named: "retweet-action-pressed"), forState: .Normal)
                self.tweet?.repostCount = self.tweet!.repostCount!.integerValue + 1
                self.repostCount.text = self.tweet?.repostCount?.description
                self.tweet?.retweeted = true
                
            })
        }
        
        
    }
    @IBAction func likeTapped(sender: AnyObject) {
        if tweet!.liked! {
            TwitterClient.sharedInstance.unlike(withID: tweet!.id!, complete: { (response, error) -> Void in
                self.likeButton.setBackgroundImage(UIImage(named: "like-action"), forState: .Normal)
                self.tweet?.likeCount = self.tweet!.likeCount!.integerValue - 1
                self.likeCount.text = self.tweet?.likeCount?.description
                self.tweet?.liked = false
                
            })
        } else {
            TwitterClient.sharedInstance.like(withID: tweet!.id!, complete: { (response, error) -> Void in
                self.likeButton.setBackgroundImage(UIImage(named: "like-action-pressed"), forState: .Normal)
                self.tweet?.likeCount = self.tweet!.likeCount!.integerValue + 1
                self.likeCount.text = self.tweet?.likeCount?.description
                self.tweet?.liked = true
                
            })
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
