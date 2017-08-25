//
//  FirstViewController.swift
//  Bizagi
//
//  Created by Edilberto Amado Perdomo on 22/08/17.
//  Copyright © 2017 Edilberto Amado Perdomo. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

/**
 * Protocolo para la ejecucion de funcion en el dismiss del controller.
 */
protocol isAbleToReceiveData {
    func pass()
}

class FirstViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, isAbleToReceiveData {
    
    @IBOutlet weak var _TableList: UITableView!
    
    let _Util = Util()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        _TableList.delegate = self
        _TableList.dataSource = self
        
        buscarListado()
    }
    
    func buscarListado(){
        
        // Mostramos un progress bar.
        
        _Util.progressBarDisplayer("Buscando", true, view)
        
        // Hacemos la peticion al nuestro WS.
        
        Alamofire.request(URL).responseArray { (response: DataResponse<[ListVacationsObject]>) in
            
            // Los datos ya se reciben mapeados, asi que podemos asignar la lista de inmediato.
            
            let listaVacaciones = response.result.value
            
            if let listaVacaciones = listaVacaciones {
                
                // Ocultamos el Progress bar.
                self._Util.afterResponse()
                
                LISTADO_VACACIONES = listaVacaciones
                
                // Refrescamos la TableView
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListVacationCell", for: indexPath) as! ListVacationCell
        
        cell._NombreSolicitante.text = LISTADO_VACACIONES[indexPath.row].employee!
        cell._FechaDeA.text = "Desde " + LISTADO_VACACIONES[indexPath.row].beginDate! + " Hasta " + LISTADO_VACACIONES[indexPath.row].endDate!
        cell._CantidadDias.text = LISTADO_VACACIONES[indexPath.row].endDate!
        cell._CantidadDias.text = _Util.calcularDias(position: indexPath.row, beginDate: LISTADO_VACACIONES[indexPath.row].beginDate!,endDate: LISTADO_VACACIONES[indexPath.row].endDate!)  + " Días"

        
        // Validamos el estado de la solicitud para decidir que imagen ponemos.

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is DetalleSolicitud{
            
            let vc = (segue.destination as! DetalleSolicitud)
            
             // Se pasan los valores al siguiente controller.
            
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
            vc.dias = _Util.calcularDias(position: (_TableList.indexPathForSelectedRow?.row)!, beginDate: LISTADO_VACACIONES[(_TableList.indexPathForSelectedRow?.row)!].beginDate!, endDate: LISTADO_VACACIONES[(_TableList.indexPathForSelectedRow?.row)!].endDate!)

            vc.delegate = self 
        }
    }
    
    /**
     * Se ejecuta cuando se hace dismiss en el detalle.
     */
    func pass() {
        self._TableList.reloadData()
    }
    
}

