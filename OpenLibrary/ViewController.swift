//
//  ViewController.swift
//  OpenLibrary
//
//  Created by David Osses Mena on 10-03-17.
//  Copyright © 2017 David Osses Mena. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imagenPortada: UIImageView!
    @IBOutlet weak var textodeBusqueda: UITextField!
    @IBOutlet weak var visorDeTexto: UITextView!
    @IBAction func `return`(_ sender: Any) {
        buscar(terminación: textodeBusqueda.text!)
    }
    var ISBN : String = ""
    var nombreLibro : String?
    var portadaLibro : String?
    var autores : [[String:String]]? = nil
    var nombreAutores : [String] = []
    var linkimagen : URL?

    var texfin : String = ""
    
    func buscar(terminación : String){
        
        let terminaciónBusqueda : String = terminación
        let urls = "http://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(terminaciónBusqueda)"
        let url = NSURL(string : urls)
        let datos : NSData? = NSData(contentsOf : url! as URL)
        
        
        
        if (datos != nil){
            
            do{
                let json = try? JSONSerialization.jsonObject(with: datos! as Data, options: JSONSerialization.ReadingOptions.mutableLeaves)
                
                let dico1 = json as! NSDictionary
                let dico2 = dico1["ISBN:\(terminaciónBusqueda)"] as! NSDictionary
                let dico3 = dico2["authors"] as! [[String:String]]
                let dico4 = dico2["cover"] as! NSDictionary
                
                let cantidad = dico3.count
                
                autores = dico3
                
                for i in 0 ..< cantidad {
                    
                    var a1 = autores?[i]
                    nombreAutores.append((a1!["name"]!))
                    
                    texfin = "\(nombreAutores[i]).  \(texfin)"
                
                }
                
                
                nombreLibro = dico2["title"] as! NSString as String
                
                let portadaLibroLarge : String? = dico4["large"] as? String
                let portadaLibroMedium : String? = dico4["medium"] as? String
                let portadaLibroSmall : String? = dico4["small"] as? String
                
                if portadaLibroLarge != nil {
                    portadaLibro = ""
                     linkimagen = URL(string: portadaLibroLarge!)
                }else if portadaLibroMedium != nil {
                    portadaLibro = ""
                     linkimagen = URL(string: portadaLibroMedium!)
                }else if portadaLibroSmall != nil {
                    portadaLibro = ""
                     linkimagen = URL(string: portadaLibroSmall!)
                }else {
                    portadaLibro = "No hay portada"
                }
               
            
            }
            let task = URLSession.shared.dataTask(with: linkimagen!) {responseData,response,error in if error == nil{
                    if let data = responseData {
                        
                        DispatchQueue.main.async {
                            self.imagenPortada.image = UIImage(data: data)
                        }
                        
                    }else {
                        print("no data")
                    }
                }else{
                    print("error")
                }
            }
            task.resume()
            
            let textoFinal = "Autor/es: \(texfin)\n\nTitulo del libro: \(nombreLibro!)\n\nPortada: \(portadaLibro!)"
            
            visorDeTexto.text = textoFinal
            
        }else{ //Si no hay datos (fallo en la conexión a Internet)
            //Mostrar mensaje de error
            let alerta = UIAlertController(title: "Error", message: "Error en la conección a internet", preferredStyle: .alert)
            
            let cancelar = UIAlertAction(title: "Cancelar", style: .cancel)
            
            alerta.addAction(cancelar)
            
            present(alerta, animated: true)
        
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    @IBAction func buscarButton(_ sender: Any) {
        
        buscar(terminación: textodeBusqueda.text!)
        
        
    }
    


}

