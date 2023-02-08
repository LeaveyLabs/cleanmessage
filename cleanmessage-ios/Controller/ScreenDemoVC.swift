//
//  ScreenDemoVC.swift
//  scdatingclub-ios
//
//  Created by Adam Novak on 2023/01/16.
//

import UIKit

class ScreenDemoVC: UIViewController {
    
    @IBOutlet var screenImageView: UIImageView!
    var screenDemoType: ScreenDemoType!
    
    //MARK: - Initialization
    
    enum ScreenDemoType: CaseIterable {
        case one, two, three, four, five
    }
    
    class func create(type: ScreenDemoType) -> ScreenDemoVC {
        let vc = UIStoryboard(name: Constants.SBID.SB.Misc, bundle: nil).instantiateViewController(withIdentifier: Constants.SBID.VC.ScreenDemo) as! ScreenDemoVC
        vc.screenDemoType = type
        return vc
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        setupLabels()
    }
    
    func setupImageView() {
        switch screenDemoType {
        case .one:
            screenImageView.image = UIImage(named: "ss1-clear")
        case .two:
            screenImageView.image = UIImage(named: "ss2-clear")
        case .three:
            screenImageView.image = UIImage(named: "ss3-clear")
        case .four:
            screenImageView.image = UIImage(named: "ss4-clear")
        case .five:
            screenImageView.image = UIImage(named: "ss5-clear")
        default:
            break
        }
    }
    
    func setupLabels() {
//        subtitleLabel.font = AppFont.medium.size(17)
//        titleLabel.font = AppFont.bold.size(25)
    }
}
