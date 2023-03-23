import Foundation
import UIKit

enum RequestError: Error {
  case invalidURL
  case missingData
}

func myfunction1(path:Data) async throws ->String
{
    let urlPath: String="https://api.replicate.com/v1/predictions"
    let url: NSURL = NSURL(string: urlPath)!
    
    let str:String = "{\"version\": \"4b32258c42e9efd4288bb9910bc532a69727f9acd26aa08e175713a0a857a608\", \"input\": {\"image\":\""+(path)+"\",\"question\":\"what is this?\"}}"
        
    let payload = str.data(using: .utf8)
    print(payload as Any)
    var request = URLRequest(url: url as URL)
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Token 92b599e3752ffb2ccba56c4564e2ffd6a06d112a", forHTTPHeaderField: "Authorization")
    request.httpMethod = "POST"
    request.httpBody=payload
    print(request.httpBody)
    
    guard let (data, _) = try? await URLSession(configuration: URLSessionConfiguration.default).data(for: request ) else{throw RequestError.invalidURL}
    //guard (response as? HTTPURLResponse)?.statusCode == 200 else {throw RequestError.invalidURL}
    let jsonResponse = String(data: data, encoding: .utf8)!
    let d = jsonResponse.data(using: String.Encoding.utf8)

    let dictonary = try JSONSerialization.jsonObject(with: d!, options: []) as? [String:AnyObject] as NSDictionary?
    var dictonary1 = try JSONSerialization.jsonObject(with: d!, options: []) as? [String:AnyObject] as NSDictionary?
    print(dictonary as Any)
    var status1:String=dictonary?["status"] as! String
    let id:String=dictonary?["id"] as! String

//    for i in [1,2,3]
//    {
//        print(i)
//        if((status1 != "succeeded"))
//        {
//
//            let st = try await myfunction2(id: id)
//            let d1 = st.data(using: String.Encoding.utf8)
//            dictonary1 = try JSONSerialization.jsonObject(with: d1!, options: []) as? [String:AnyObject] as NSDictionary?
//            print(dictonary1!)
//            status1=dictonary1?["status"] as! String
//        }
//    }
//    if(status1 == "succeeded")
//    {
//        print(dictonary1?["output"] as! String)
//        return dictonary1?["output"] as! String
//                                   }
    return "Hi"
    }



func myfunction2(id:String) async throws ->String {

    let urlPath: String = "https://api.replicate.com/v1/predictions/"+id

    let url: NSURL = NSURL(string: urlPath)!
    var request = URLRequest(url: url as URL)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Token 92b599e3752ffb2ccba56c4564e2ffd6a06d112a", forHTTPHeaderField: "Authorization")
    
    guard let (data, response) = try? await URLSession.shared.data(for: request ) else{throw RequestError.invalidURL}
  guard (response as? HTTPURLResponse)?.statusCode == 200 else {throw RequestError.invalidURL}
    
    let jsonResponse = String(data: data, encoding: .utf8)!
  return jsonResponse
   
}

func documentDirectoryPath() -> URL? {
    let path = FileManager.default.urls(for: .documentDirectory,
                                        in: .userDomainMask)
    
    return path.first
}
func savePng(image: UIImage) -> Data {
    var imageData=Data()
    
//    if let pngData = image.pngData(),
    var path = (documentDirectoryPath()?.appendingPathComponent("example.png"))!
//        try? pngData.write(to: path)
//        d=pngData
//        print(d)
//        return d
//    }
    do {
             imageData = try Data(contentsOf: path as URL)
        print(imageData)
            
        } catch {
            print("Unable to load data: \(error)")
        }
    return imageData
}

func replicate(img:UIImage) async throws -> String{
    let path:Data = savePng(image: img)
    print(path)
    print(path.base64EncodedData())
    //return path
    do {
        try await print(myfunction1(path:path))
    } catch is Error{
        print("invalid URL")
    }

    return "Done"
}
