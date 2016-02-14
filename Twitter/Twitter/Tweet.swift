//
//  Tweet.swift
//  Twitter
//
//  Created by went,cui on 2/6/16.
//  Copyright © 2016 frostao. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createAt: NSDate?
    var likeCount: NSNumber?
    var repostCount: NSNumber?
    var id: NSNumber?
    var retweeted: Bool?
    var liked: Bool?
    
    init(dictionary: NSDictionary) {
        //print(dictionary)
        likeCount = dictionary["favorite_count"] as? NSNumber
        let retweeted_status = dictionary["retweeted_status"]
        if let retweeted_status = retweeted_status as? NSDictionary {
            likeCount = retweeted_status["favorite_count"] as? NSNumber
            
        }
        
        
        
        
        
        repostCount = dictionary["retweet_count"] as? NSNumber
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        id = dictionary["id"] as? NSNumber
        retweeted = dictionary["retweeted"] as? Bool
        liked = dictionary["favorited"] as? Bool
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createAt = formatter.dateFromString(createdAtString!)
    }
    
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
            
        }
        
        return tweets
    }
}
