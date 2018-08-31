//
//  ViewController.swift
//  UltraTimer
//
//  Created by Lu Yunchi on 2018/8/23.
//  Copyright © 2018年 Lu Yunchi. All rights reserved.
//

import UIKit
import SnapKit
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var but1: UIButton!//left button
    @IBOutlet weak var but2: UIButton!//right button
    @IBOutlet weak var label: UILabel!//time label
    @IBOutlet weak var table: UITableView!//table for recorded time
    let timer=DispatchSource.makeTimerSource(queue: DispatchQueue.global())
    var ms:Int=0
    var array=[Int]()
    var isrunning:Bool=false
    override func viewDidLoad() {
        super.viewDidLoad()
        setbut()
        settext()
        setbutst(but2,false)
        settimer()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func setbut(){//button setting
        but1.frame=CGRect(x: 1/8*self.view.frame.width, y: 1/3*self.view.frame.height, width: 1/4*self.view.frame.width, height:1/4*self.view.frame.width)
        but1.tintColor=UIColor.white
        but1.backgroundColor=UIColor.init(red: 80/255, green: 200/255, blue: 200/255, alpha: 1)
        but1.setTitle("Start", for: UIControlState.normal)
        but1.layer.cornerRadius=1/8*self.view.frame.width
        but1.titleLabel?.font=UIFont(name: "Optima", size: 20)
        self.view.addSubview(but1)
        but2.frame=CGRect(x: 5/8*self.view.frame.width, y: 1/3*self.view.frame.height, width: 1/4*self.view.frame.width, height: 1/4*self.view.frame.width)
        but2.tintColor=UIColor.white
        but2.backgroundColor=UIColor.init(red: 255/255, green: 100/255, blue: 100/255, alpha: 1)
        but2.setTitle("Stop", for: UIControlState.normal)
        but2.layer.cornerRadius=1/8*self.view.frame.width
        but2.titleLabel?.font=UIFont(name: "Optima", size: 20)
        self.view.addSubview(but2)
    }
    //label and tableview setting
    func settext(){
        label.text="00:00:00"
        label.font=UIFont(name: "Optima", size: 60)
        label.frame=CGRect(x: 0, y: 1/8*self.view.frame.height, width: self.view.frame.width, height: 100)
        label.textAlignment=NSTextAlignment.center
        
        table.frame=CGRect(x: 0, y: self.view.frame.height/2, width: self.view.frame.width, height: self.view.frame.height/2)
       // table.delegate=self
        table.dataSource=self
        }
    //realizing protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=UITableViewCell(style: .default, reuseIdentifier: "rec")
        let t=array[indexPath.row]
        let a=t/60000
        let b=t%60000/100
        let c=t%100
        let s=String(format: "%3d               %02d:%02d:%02d", indexPath.row+1,a,b,c)
        cell.textLabel?.text=s
        cell.textLabel?.textColor=UIColor.gray
        cell.textLabel?.font=UIFont(name: "Optima", size: 25)
        cell.textLabel?.textAlignment=NSTextAlignment.center
        return cell
    }
    //function for changing button state
    func setbutst(_ button:UIButton, _ bool:Bool){
        button.isEnabled=bool
        if bool {
            button.alpha=1
        }else{
            button.alpha=0.6
        }
    }
    //click action
    @IBAction func lbaction(_ sender: Any) {
        if but1.titleLabel?.text == "Start"{
            guard isrunning==false else {return}
            but1.setTitle("Record", for: .normal)
            setbutst(but2,true)
            timer.resume()
            isrunning=true
        }else if but1.titleLabel?.text == "Record"{
            array.append(ms)
            table.reloadData()
        }else if but1.titleLabel?.text == "Continue"{
            guard isrunning==false else {return}
            but1.setTitle("Record", for: .normal)
            but2.setTitle("Stop", for: .normal)
            timer.resume()
            isrunning=true
        }
    }
    @IBAction func rbaction(_ sender: Any) {
        if but2.titleLabel?.text == "Stop"{
            guard isrunning==true else {return}
            but2.setTitle("Reset", for: .normal)
            but1.setTitle("Continue", for: .normal)
            timer.suspend()
            isrunning=false
        }else if but2.titleLabel?.text == "Reset"{
            but1.setTitle("Start", for: .normal)
            but2.setTitle("Stop", for: .normal)
            setbutst(but2,false)
            ms=0
            array.removeAll()
            label.text="00:00:00"
            table.reloadData()
        }
    }
    //initialize timer
    func settimer(){
        timer.schedule(deadline: .now(), repeating: 0.01)
        timer.setEventHandler(handler: {DispatchQueue.main.async {self.timing()}})
        if timer.isCancelled {return}
    }
    //timing
    @objc func timing(){
        ms+=1
        show()
    }
    //label show the time
    func show(){
        let a=ms/60000
        let b=ms%60000/100
        let c=ms%100
        let s=String(format: "%02d:%02d:%02d", a,b,c)
        label.text=s
    }
   
}

