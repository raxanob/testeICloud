//
//  ViewController.swift
//  IClaudAula
//
//  Created by Rayane Xavier on 03/03/20.
//  Copyright © 2020 Rayane Xavier. All rights reserved.
//

import UIKit
import CloudKit
class ViewController: UIViewController {
    
    @IBOutlet weak var imageUIImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var curseLabel: UILabel!
    
    @IBOutlet weak var tiaLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var curseTextField: UITextField!
    
    @IBOutlet weak var tiaTextField: UITextField!
    
    @IBOutlet weak var searchNameTextField: UITextField!
    
    @IBAction func addButton(_ sender: Any) {
        addStudent()
    }
    
    @IBAction func searchButton(_ sender: Any) {
        searchStudent()
    }
    
    let container = CKContainer.init(identifier: "iCloud.AulaTeste.Rayane")
    lazy var db = container.publicCloudDatabase
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func addStudent() {
        let aluno = CKRecord(recordType: "aluno")
        aluno.setValue(nameTextField.text, forKey: "Nome")
        aluno.setValue(curseTextField.text, forKey: "Curso")
        aluno.setValue(tiaTextField.text, forKey: "Tia")
        db.save(aluno) { (record, error) in
            if let err = error {
                fatalError(err.localizedDescription)
            } else {
                let nome = record?.value(forKey: "Nome")
            }
        }
    }
    
    func searchStudent() {
        let predicate = NSPredicate(format: "Nome == %@", searchNameTextField.text ?? "")
        let query = CKQuery(recordType: "aluno", predicate: predicate)
        
        db.perform(query, inZoneWith: nil) {(records, error) in
            if let err = error {
                fatalError(err.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    for aluno in records!{
                        let url = (aluno["Foto"] as! CKAsset).fileURL
                        self.nameLabel.text = aluno.value(forKey: "Nome") as? String
                        self.curseLabel.text = aluno.value(forKey: "Curso") as? String
                        self.tiaLabel.text = aluno.value(forKey: "Tia") as? String
                        if let data = try? Data(contentsOf: url!), let image = UIImage(data: data) {
                            self.imageUIImage.image = image
                        }
                    }
                }
            }
        }
    }
    
    func deleteStudent() {
        let predicate = NSPredicate(format: "Nome == %@", searchNameTextField.text ?? "")
        let query = CKQuery(recordType: "aluno", predicate: predicate)
        
        db.perform(query, inZoneWith: nil) {(records, error) in
            if let err = error {
                fatalError(err.localizedDescription)
            } else {
                for aluno in records!{
                    self.db.delete(withRecordID: aluno.recordID) { (record, error) in
                        if let err = error {
                            fatalError(err.localizedDescription)
                        } else {
                            let nome = record?.value(forKey: "Nome")
                        }
                    }
                    print(aluno.value(forKey: "Nome"))
                }
            }
        }
    }
}

