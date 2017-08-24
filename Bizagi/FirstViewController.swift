//
//  FirstViewController.swift
//  Bizagi
//
//  Created by Edilberto Amado Perdomo on 22/08/17.
//  Copyright © 2017 Edilberto Amado Perdomo. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var _TableList: UITableView!
    var listaPregunta = NSArray()
    var idQuestion = String()
    var pregunta = String()
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        _TableList.delegate = self
        _TableList.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
   
    //MARK: - UITableView Delegate -
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //user search
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListVacationCell", for: indexPath) as! ListVacationCell
        
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is DetalleSolicitud{
            let _ = (segue.destination as! DetalleSolicitud)
        }
    }
    
    var _StrLabel = UILabel()
    var _MessageFrame = UIView()
    var _ActivityIndicator = UIActivityIndicatorView()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("por aca ando")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetalleSolicitud") as! DetalleSolicitud
        present(vc, animated: true, completion: nil)
        
    }
    // MARK: Custom functions
    func progressBarDisplayer(_ msg:String, _ indicator:Bool ) {
        
        _StrLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        _StrLabel.text = msg
        _StrLabel.textColor = UIColor.white
        _MessageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
        _MessageFrame.layer.cornerRadius = 15
        _MessageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            _ActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
            _ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            _ActivityIndicator.startAnimating()
            _MessageFrame.addSubview(_ActivityIndicator)
        }
        _MessageFrame.addSubview(_StrLabel)
        view.addSubview(_MessageFrame)
    }
    
    func afterResponse(_Genre: String)
    {
        
        _MessageFrame.removeFromSuperview()
        
        let vc: DetalleSolicitud = DetalleSolicitud(nibName: "DetalleSolicitud", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        /*
         let cvc = AppsCVCCollectionViewController(nibName: "AppsCVCCollectionViewController", bundle: nil)
         self.navigationController?.pushViewController(cvc, animated: true)*/
    }
    

    

    
    
}

