//
//  SecondViewController.swift
//  Bizagi
//
//  Created by Edilberto Amado Perdomo on 22/08/17.
//  Copyright © 2017 Edilberto Amado Perdomo. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

import Firebase
import FirebaseDatabase

class SecondViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, isAbleToReceiveData {
    
    
    var ref: DatabaseReference!
    
    
    @IBOutlet weak var _TableList: UITableView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        _TableList.delegate = self
        _TableList.dataSource = self
        
        buscarLisatdo()
        
        
        ref = Database.database().reference()
        
        let empleados = self.ref.child("empleados")
        
        empleados.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            
            print(snapshot)
            
        })
        print(self.ref.child("empleados").childByAutoId())
        
        
    }
    
    func buscarLisatdo(){
        
        progressBarDisplayer("Buscando", true)
        
        Alamofire.request(URL).responseArray { (response: DataResponse<[ListVacationsObject]>) in
            
            let listaVacaciones = response.result.value
            
            if let listaVacaciones = listaVacaciones {
                
                self.afterResponse()
                
                LISTADO_VACACIONES = listaVacaciones
                
                self._TableList.reloadData()
                
            }
        }
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
        return LISTADO_VACACIONES.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //user search
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListVacationCell", for: indexPath) as! ListVacationCell
        
        
        
        cell._NombreSolicitante.text = LISTADO_VACACIONES[indexPath.row].employee!
        cell._FechaDeA.text = "Desde " + LISTADO_VACACIONES[indexPath.row].beginDate! + " Hasta " + LISTADO_VACACIONES[indexPath.row].endDate!
        cell._CantidadDias.text = LISTADO_VACACIONES[indexPath.row].endDate!
        cell._CantidadDias.text = calcularDias(position: indexPath.row) + " Días"
        
        if LISTADO_VACACIONES[indexPath.row].approved == "aprobado" {
            cell._ImgEstado.image = UIImage(named:"img-aprobado.png")!
        }else if LISTADO_VACACIONES[indexPath.row].approved == "rechazado"{
            cell._ImgEstado.image = UIImage(named:"img-rechazada.png")!
            
        }else{
            cell._ImgEstado.image = UIImage(named:"img-pendiente.png")!
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetalleSolicitud") as! DetalleSolicitud
        present(vc, animated: true, completion: nil)
        
        
        
    }
    
    func pass() {
        self._TableList.reloadData()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is DetalleSolicitud{
            
            let vc = (segue.destination as! DetalleSolicitud)
            
            vc.lastVacationOn = LISTADO_VACACIONES[(_TableList.indexPathForSelectedRow?.row)!].lastVacationOn!
            vc.processId = LISTADO_VACACIONES[(_TableList.indexPathForSelectedRow?.row)!].processId!
            vc.endDate = LISTADO_VACACIONES[(_TableList.indexPathForSelectedRow?.row)!].endDate!
            vc.process = LISTADO_VACACIONES[(_TableList.indexPathForSelectedRow?.row)!].process!
            vc.beginDate = LISTADO_VACACIONES[(_TableList.indexPathForSelectedRow?.row)!].beginDate!
            vc.activityId = LISTADO_VACACIONES[(_TableList.indexPathForSelectedRow?.row)!].activityId!
            vc.requestDate = LISTADO_VACACIONES[(_TableList.indexPathForSelectedRow?.row)!].requestDate!
            vc.activity = LISTADO_VACACIONES[(_TableList.indexPathForSelectedRow?.row)!].activity!
            vc.employee = LISTADO_VACACIONES[(_TableList.indexPathForSelectedRow?.row)!].employee!
            vc.approved = LISTADO_VACACIONES[(_TableList.indexPathForSelectedRow?.row)!].approved!
            vc.position = (_TableList.indexPathForSelectedRow?.row)!
            vc.dias = calcularDias(position: (_TableList.indexPathForSelectedRow?.row)!) + " Días"
            vc.delegate = self
        }
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
    
    func afterResponse()
    {
        
        _MessageFrame.removeFromSuperview()
        
    }
    
    func calcularDias(position: Int) -> String
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        let beginDate = dateFormatter.date(from: LISTADO_VACACIONES[position].beginDate!)
        let endDate = dateFormatter.date(from: LISTADO_VACACIONES[position].endDate!)
        
        let calendar = NSCalendar.current
        
        let fecha_desde = calendar.startOfDay(for: beginDate!)
        let fecha_hasta = calendar.startOfDay(for: endDate!)
        
        let dias = Set<Calendar.Component>([.day])
        let result = calendar.dateComponents(dias, from: fecha_desde as   Date,  to: fecha_hasta as Date)
        
        return String(describing: result.day!)
    }
    
    
}

