//
//  SecondViewController.swift
//  Bizagi
//
//  Created by Edilberto Amado Perdomo on 22/08/17.
//  Copyright © 2017 Edilberto Amado Perdomo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SecondViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var _TableList: UITableView!
    
    var ref: DatabaseReference!
    var _ListadoVacaciones = [ListVacationsObject]()
    
    let _Util = Util()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Referenciamos nuestra base de datos.
        
        ref = Database.database().reference()
        
        _TableList.delegate = self
        _TableList.dataSource = self
        
        buscarListado()
        
    }
    
    func buscarListado(){
        
        // Mostramos un progress bar.
        
        _Util.progressBarDisplayer("Buscando", true, view)
        
        // Referenciamos la lista.
        
        let empleados = self.ref.child("empleados")
        
        // Este observable se llamara cada vez que se realice un cambio en la base de datos.
        empleados.observe(DataEventType.value, with: { (vacaciones) in
            
            if vacaciones.childrenCount > 0 {
                
                // Desocupamos la lista actual.
                self._ListadoVacaciones.removeAll()
                
                // Llenamos la lista con los nuevos datos.
                for empleado in vacaciones.children.allObjects as! [DataSnapshot] {
                    
                    let empleadoDatos = empleado.value as? [String: AnyObject]
                    
                    let data = ListVacationsObject(lastVacationOn: empleadoDatos?["lastVacationOn"] as! String?,
                                                   processId: empleadoDatos?["processId"] as! String?,
                                                   endDate: empleadoDatos?["endDate"] as! String?,
                                                   process: empleadoDatos?["process"] as! String?,
                                                   beginDate: empleadoDatos?["beginDate"] as! String?,
                                                   activityId: empleadoDatos?["activityId"] as! String?,
                                                   requestDate: empleadoDatos?["requestDate"] as! String?,
                                                   activity: empleadoDatos?["activity"] as! String?,
                                                   employee: empleadoDatos?["employee"] as! String?,
                                                   approved: empleadoDatos?["approved"] as! String?)
                    
                    // Adicionamos a la lista
                    self._ListadoVacaciones.append(data)
                }
                self._Util.afterResponse()
                // Refrescamos la tableview
                self._TableList.reloadData()
            }
        })
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
        return _ListadoVacaciones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListVacationCell", for: indexPath) as! ListVacationCell
        
        cell._NombreSolicitante.text = _ListadoVacaciones[indexPath.row].employee!
        cell._FechaDeA.text = "Desde " + _ListadoVacaciones[indexPath.row].beginDate! + " Hasta " + _ListadoVacaciones[indexPath.row].endDate!
        cell._CantidadDias.text = _ListadoVacaciones[indexPath.row].endDate!
        cell._CantidadDias.text = _Util.calcularDias(position: indexPath.row, beginDate: _ListadoVacaciones[indexPath.row].beginDate!,endDate: _ListadoVacaciones[indexPath.row].endDate!)  + " Días"
        
        // Validamos el estado de la solicitud para decidir que imagen ponemos.
        
        if _ListadoVacaciones[indexPath.row].approved == APROBADO {
            cell._ImgEstado.image = UIImage(named:"img-aprobado.png")!
        }else if _ListadoVacaciones[indexPath.row].approved == RECHAZADO{
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is DetalleSolicitudFireBase{
            
            let vc = (segue.destination as! DetalleSolicitudFireBase)
            
            // Se pasan los valores al siguiente controller.
            
            vc.lastVacationOn = _ListadoVacaciones[(_TableList.indexPathForSelectedRow?.row)!].lastVacationOn!
            vc.processId = _ListadoVacaciones[(_TableList.indexPathForSelectedRow?.row)!].processId!
            vc.endDate = _ListadoVacaciones[(_TableList.indexPathForSelectedRow?.row)!].endDate!
            vc.process = _ListadoVacaciones[(_TableList.indexPathForSelectedRow?.row)!].process!
            vc.beginDate = _ListadoVacaciones[(_TableList.indexPathForSelectedRow?.row)!].beginDate!
            vc.activityId = _ListadoVacaciones[(_TableList.indexPathForSelectedRow?.row)!].activityId!
            vc.requestDate = _ListadoVacaciones[(_TableList.indexPathForSelectedRow?.row)!].requestDate!
            vc.activity = _ListadoVacaciones[(_TableList.indexPathForSelectedRow?.row)!].activity!
            vc.employee = _ListadoVacaciones[(_TableList.indexPathForSelectedRow?.row)!].employee!
            vc.approved = _ListadoVacaciones[(_TableList.indexPathForSelectedRow?.row)!].approved!
            vc.dias = _Util.calcularDias(position: (_TableList.indexPathForSelectedRow?.row)!, beginDate: _ListadoVacaciones[(_TableList.indexPathForSelectedRow?.row)!].beginDate!, endDate: _ListadoVacaciones[(_TableList.indexPathForSelectedRow?.row)!].endDate!)
            
            vc.position = (_TableList.indexPathForSelectedRow?.row)!
        }
    }
    
}

