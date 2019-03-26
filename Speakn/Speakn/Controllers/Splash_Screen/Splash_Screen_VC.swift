//
//  Splash_Screen_VC.swift
//  Speakn
//
//  Created by Sergio Rosendo on 3/20/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import UIKit

class Splash_Screen_VC: UIViewController {
    // User interface elements
    var mascot_image: UIImageView!
    var title_image: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup_user_interface_elements()
        self.animate_screen()
    }
    
    func setup_user_interface_elements(){
        let screen_width = self.view.frame.width
        let screen_height = self.view.frame.height
        let screen_mid_x = self.view.frame.midX
        let screen_mid_y = self.view.frame.midY
        let screen_min_y = self.view.frame.minY
        
        self.mascot_image = UIImageView()
        self.mascot_image.frame.size = CGSize(width: screen_width * 0.2, height: screen_height * 0.11)
        self.mascot_image.frame.origin = CGPoint(x: screen_mid_x - self.mascot_image.frame.width / 2, y: screen_min_y - self.mascot_image.frame.width / 2)
        self.mascot_image.image = UIImage(named: "Mascot_1")
        self.mascot_image.contentMode = .scaleAspectFit
        self.mascot_image.alpha = 0
        self.view.addSubview(mascot_image)
        
        self.title_image = UIImageView()
        self.title_image.frame.size = CGSize(width: screen_width * 0.44, height: screen_height * 0.09)
        self.title_image.frame.origin = CGPoint(x: screen_mid_x - self.title_image.frame.width / 2, y: screen_mid_y - (self.title_image.frame.height * 0.90))
        self.title_image.image = UIImage(named: "Title")
        self.title_image.contentMode = .scaleAspectFit
        self.title_image.alpha = 0
        self.view.addSubview(title_image)
    }
    
    func animate_screen(){
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
            self.mascot_image.alpha = 1
            self.mascot_image.transform =  CGAffineTransform(translationX: 0, y: self.view.frame.midY - self.mascot_image.frame.height)
        }) { (_) in
            UIView.animate(withDuration: 1.0, animations: {
                self.title_image.alpha = 1
                self.mascot_image.image = UIImage(named: "Mascot_2")
            }, completion: { (_) in
                UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                    self.mascot_image.alpha = 0
                    self.title_image.alpha = 0
                }, completion:
                { (_) in
                    self.performSegue(withIdentifier: "First_Screen_Segue", sender: nil)
                })
            })
        }
    }
}
