//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by Yapzi on 16/5/20.
//  Copyright © 2016年 Yap. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    @IBOutlet var backgroundImageView: UIImageView!
//    @IBOutlet var ratingStackView: UIStackView!
    @IBOutlet var ratingGoodButton: UIButton!
    @IBOutlet var ratingGreatButton: UIButton!
    @IBOutlet var ratingDislikeButton: UIButton!
    @IBAction func updateRating(sender: UIButton) {
        switch sender.tag {
        case 0: self.rating = "great"
        case 1: self.rating = "good"
        case 2: self.rating = "dislike"
        default: break
        }
    self.performSegueWithIdentifier("unwindToDetailView", sender: sender)
    }
    var rating: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
//        let transform1 = CGAffineTransformMakeScale(0.0, 0.0)
//        let transform2 = CGAffineTransformMakeTranslation(0, 500)
//        ratingStackView.transform = CGAffineTransformConcat(transform1, transform2)
        let transform = CGAffineTransformMakeTranslation(0, 500)
        ratingGoodButton.transform = transform
        ratingGreatButton.transform = transform
        ratingDislikeButton.transform = transform
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
//        UIView.animateWithDuration(0.7, delay: 0.0, options: [], animations: {() -> Void in
//            self.ratingStackView.transform = CGAffineTransformIdentity}, completion: nil)
//        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: [], animations: {self.ratingStackView.transform = CGAffineTransformIdentity
//            }, completion: nil)  StackView 整体动画
        UIView.animateKeyframesWithDuration(0.4, delay: 0.0, options: [], animations: {self.ratingGoodButton.transform = CGAffineTransformIdentity}, completion: nil)
        UIView.animateKeyframesWithDuration(0.4, delay: 0.3, options: [], animations: {self.ratingGreatButton.transform = CGAffineTransformIdentity}, completion: nil)
        UIView.animateKeyframesWithDuration(0.4, delay: 0.6, options: [], animations: {self.ratingDislikeButton.transform = CGAffineTransformIdentity}, completion: nil)
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
