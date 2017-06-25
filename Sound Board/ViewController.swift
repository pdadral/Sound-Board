//
//  ViewController.swift
//  Sound Board
//
//  Created by Dadral on 25/06/17.
//  Copyright © 2017 Dadral. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var sounds : [Sound] = []
    
    var audioPlayer : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        do{
            sounds = try context.fetch(Sound.fetchRequest())
            
            tableView.reloadData()
        }catch{}
        
        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        let sound = sounds[indexPath.row]
        print("###### SOunds")
        //print(sound)
        cell.textLabel?.text = sound.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sound = sounds[indexPath.row]
        
        do{
            audioPlayer = try AVAudioPlayer(data: sound.audio! as Data)
            audioPlayer?.play()
        }catch{}
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
             print("hello")
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let sound = sounds[indexPath.row]
            
            context.delete(sound)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do{
                sounds = try context.fetch(Sound.fetchRequest())
                
                tableView.reloadData()
            }catch{}
        }
       
    }
    
}

