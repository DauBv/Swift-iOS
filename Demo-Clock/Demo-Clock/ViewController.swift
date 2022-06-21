//
//  ViewController.swift
//  Demo-Clock
//
//  Created by VINICORP JSC on 21/06/2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var clockView: UIImageView!
    @IBOutlet weak var kimGioView: UIView!
    @IBOutlet weak var kimPhutView: UIView!
    @IBOutlet weak var kimGiayView: UIView!
    @IBOutlet weak var centerView: UIView!
    
    let currentDate = Date()
    let calendar = NSCalendar.current
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        runDongHo()
    }

    func setupUI() {
        view.bringSubviewToFront(centerView)
        centerView.frame.size = CGSize(width: 15, height: 15)
        centerView.center = view.center
        centerView.layer.cornerRadius = centerView.bounds.width/2
        centerView.layer.masksToBounds = true
        centerView.backgroundColor = .black
        
        kimGioView?.frame.size = CGSize(width: clockView.bounds.size.width / 10 * 2.5, height: 4)
        kimGioView.center = centerView.center
        
        kimPhutView?.frame.size = CGSize(width: clockView.bounds.size.width / 10 * 3, height: 3)
        kimPhutView.center = centerView.center

        kimGiayView?.frame.size = CGSize(width: clockView.bounds.size.width / 10 * 3.5, height: 3)
        kimGiayView.center = centerView.center
    }
    
    func setAnchorPoint(kimView: UIView, point: CGPoint) {
        kimView.layer.anchorPoint = point
    }
    
    func getLocation(kimView: UIView, alpha: CGFloat) {
        let r = kimView.bounds.size.height / 2
        kimView.layer.cornerRadius = r // bo viền
        
        self.setAnchorPoint(kimView: kimView, point: CGPoint(x: 0, y: 0.5))
        kimView.transform = CGAffineTransform(rotationAngle: alpha)
    }
    
    func runDongHo() {
        getLocation(kimView: kimGioView, alpha: setTimer().hour)
        getLocation(kimView: kimPhutView, alpha: setTimer().minute)
        getLocation(kimView: kimGiayView, alpha: setTimer().second)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runLoop), userInfo: nil, repeats: true)
    }
    
    @objc func runLoop() {
        let omegaGiay = CGAffineTransform(rotationAngle: CGFloat.pi*2/60)
        let omegaPhut = CGAffineTransform(rotationAngle: CGFloat.pi*2/60/60)
        let omegaGio = CGAffineTransform(rotationAngle: CGFloat.pi*2/60/60/12)
        
        self.kimGiayView.transform = kimGiayView.transform.concatenating(omegaGiay)
        self.kimPhutView.transform = kimPhutView.transform.concatenating(omegaPhut)
        self.kimGioView.transform = kimGioView.transform.concatenating(omegaGio)
    }
    
    func setTimer() -> (hour: CGFloat, minute: CGFloat, second: CGFloat) {
        let hour = calendar.component(.hour, from: currentDate as Date)
        let minute = calendar.component(.minute, from: currentDate as Date)
        let second = calendar.component(.second, from: currentDate as Date)
        
        let hourInAboutSecond = (hour * 60 * 60) + (minute * 60) + second
        let minuteInAbountSecond = (minute * 60) + second
        let firstAlphaHour = CGFloat.pi * (2*CGFloat(hourInAboutSecond)/12/60/60 - 0.5)
        let firstAlphaMinute = CGFloat.pi * (2*CGFloat(minuteInAbountSecond)/60/60 - 0.5)
        let firstAlphaSecond = CGFloat.pi * (2*CGFloat(second)/60 - 0.5)
        return (firstAlphaHour, firstAlphaMinute, firstAlphaSecond)
    }
}

