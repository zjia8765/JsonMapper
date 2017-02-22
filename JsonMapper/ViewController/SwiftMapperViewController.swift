//
//  SwiftMapperViewController.swift
//  JsonMapper
//
//  Created by zhangjia on 2017/2/21.
//  Copyright © 2017年 zhangjia. All rights reserved.
//

import UIKit
import ObjectMapper

class SwiftMapperViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func showPropertyList(_ sender: Any) {
        print("start propertyList")
        let classArray = ["JsonMapper.GlobalRaceSwiftModel","JsonMapper.RaceSourceSwiftModel"]
        for name in classArray {
            print("<<<<<<<<<<<<<<<<<<<<begin \(name)  property<<<<<<<<<<<<")
            let cls:AnyClass = objc_getClass(name) as! AnyClass;
            var propertyNum:UInt32 = 0
            let propertyList = class_copyPropertyList(cls, &propertyNum)
            for index in 0..<numericCast(propertyNum) {
                let property:objc_property_t = propertyList![index]!
                 print((String(cString: property_getName(property)!)), String(cString: property_getAttributes(property)!));
                
            }
            print("<<<<<<<<<<<<<<<<<<<<end \(name) property<<<<<<<<<<<<")
        }
        
    }
    
    
    @IBAction func analysisModel(_ sender: Any) {
        
        let dataPath:String = Bundle.main.path(forResource: "data", ofType: "json")!
        let jsonData =  try? Data.init(contentsOf:  URL.init(fileURLWithPath: dataPath))
        if let jsonDic = try? JSONSerialization.jsonObject(with: jsonData!, options: []) as? [String:Any],
            let result = jsonDic?["result"] {
            let raceModel:GlobalRaceSwiftModel? = Mapper<GlobalRaceSwiftModel>().map(JSONObject: result)
            print(raceModel?.toJSONString() ?? "nil")
        }
        

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
