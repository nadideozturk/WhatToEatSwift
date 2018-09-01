//
//  OutsideMealDetailViewController.swift
//  WhatToEatLocal
//
//  Created by Engin Oruc Ozturk on 5.08.2018.
//  Copyright © 2018 NadideOzturk. All rights reserved.
//

import UIKit
import Cloudinary

class OutsideMealDetailViewController: UIViewController {
    
    // MARK: - Properties
    var  meal:OutsideMeal? = nil
    
    var config = CLDConfiguration(cloudName: "dv0qmj6vt", apiKey: "752346693282248")
    var cloudinary:CLDCloudinary! = nil
    
    @IBOutlet weak var lblOutsideMealName: UILabel!
    
    @IBOutlet weak var lblOutsideMealPrice: UILabel!
    
    @IBOutlet weak var lblOutsideMealDate: UILabel!
    
    
    @IBOutlet weak var imgViewerOutsideMeal: UIImageView!
    
    
    @IBAction func editBtnClicked(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showOutsideMealEditSegue", sender: UIBarButtonItem.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cloudinary = CLDCloudinary(configuration: self.config)
        if meal != nil {
            lblOutsideMealName.text = (meal?.name.capitalized)! + " at " + (meal?.restaurantName.capitalized)!
            let price:String = String(format:"%.2f", (meal?.price)!)
            lblOutsideMealPrice.text = price  + " CDN"
            lblOutsideMealDate.text = calculatetimePassed(lastEatenDate: (meal?.lastEatenDate)!)
            imgViewerOutsideMeal.image = #imageLiteral(resourceName: "HolderImage")
            loadImageForDetail(urlStr: (meal?.photoUrl)!, imgViewer: imgViewerOutsideMeal)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOutsideMealEditSegue" {
            let editVC: OutsideMealEditViewController = segue.destination as! OutsideMealEditViewController
            editVC.meal = self.meal
        }
    }
    
    // MARK: - Private Functions
    func calculatetimePassed(lastEatenDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let aDate = dateFormatter.date(from: lastEatenDate)
        let timeInterval = aDate?.timeIntervalSinceNow
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.unitsStyle = .full
        dateComponentsFormatter.allowedUnits = [.year, .month, .weekOfMonth, .day]
        let dateString = dateComponentsFormatter.string(from: abs(timeInterval!))
        let strDate:String = (dateString?.uppercased())! + " AGO"
        return strDate
    }
    private func loadImageForDetail(urlStr: String, imgViewer: UIImageView!) {
        let url = URL(string: urlStr)
        do {
            self.cloudinary.createDownloader().fetchImage(urlStr, nil, completionHandler: { (result,error) in
                if let error = error {
                    print("Error downloading image %@", error)
                }
                else {
                    print("Image downloaded from Cloudinary successfully")
                    do{
                        let data = try Data(contentsOf: url!)
                        var image: UIImage?
                        image = UIImage(data: data)
                        DispatchQueue.main.async {
                            imgViewer.image = image
                        }
                    }
                    catch _ as NSError{
                    }
                }
                
            })
        }catch {
        }
    }


}
