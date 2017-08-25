//
//  DetalleSolicitudFireBase.swift
//  Bizagi
//
//  Created by Edilberto Amado P on 25/08/17.
//  Copyright © 2017 Edilberto Amado Perdomo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class DetalleSolicitudFireBase: UIViewController {
    
    @IBOutlet weak var _NombreEmpleado: UILabel!
    @IBOutlet weak var _FechaSolicitud: UILabel!
    @IBOutlet weak var _UltimasVacaciones: UILabel!
    @IBOutlet weak var _Desde: UILabel!
    @IBOutlet weak var _Hasta: UILabel!
    @IBOutlet weak var _CantidadDias: UILabel!
    @IBOutlet weak var _Estado: UILabel!
    
    var ref: DatabaseReference!
    var empleados: DatabaseReference!
    
    var position = 0
    var lastVacationOn: String = ""
    var processId: String = ""
    var endDate: String = ""
    var process: String = ""
    var beginDate: String = ""
    var activityId: String = ""
    var requestDate: String = ""
    var activity: String = ""
    var employee: String = ""
    var approved: String = ""
    var dias: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        empleados = self.ref.child("empleados")
        
        _NombreEmpleado.text = employee
        
        _FechaSolicitud.text = "Fecha de solicitud \(requestDate)"
        _UltimasVacaciones.text = "Ultimas vacaciones: \(lastVacationOn)"
        _Desde.text = "A partir de: \(beginDate)"
        _Hasta.text = "Hasta: \(endDate)"
        _CantidadDias.text = "Cantidad días: \(dias)"
        
        // Validamos el estado de la solicitud.
        
        if approved == APROBADO {
            _Estado.text = "Estado: Aprobado"
            
        }else if approved == RECHAZADO{
            _Estado.text = "Estado: Rechazado"
            
        }else{
            _Estado.text = "Estado: Pendiente"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func cerrar(_ sender: Any) {
        
        self.dismiss(animated: true);
    }
    
    @IBAction func btnAprobar(_ sender: Any) {
        
        updateArtist(approved: "aprobado")
        self.dismiss(animated: true);
        
    }
    
    @IBAction func btnRechazar(_ sender: Any) {
        
        updateArtist(approved: "rechazado")
        self.dismiss(animated: true);
        
    }
    

    /**
     * Actualizamos los datos en Firebase.
     */
    func updateArtist(approved:String){
        
        let update = [
            "lastVacationOn" : lastVacationOn,
            "processId" : processId,
            "endDate" : endDate,
            "process" : process,
            "beginDate" : beginDate,
            "activityId" : activityId,
            "requestDate" : requestDate,
            "activity" : activity,
            "employee" : employee,
            "approved": approved]
        
        empleados.child(String(position)).setValue(update)
        
    }
    
}
