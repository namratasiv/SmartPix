import SwiftUI
import PhotosUI
import Laden

struct ContentView: View {
    @State private var isShowPhotoLibrary = false
    @State private var isDone = true
    @State private var showForm = false
    @State private var inputImage : UIImage=UIImage()
    
        var body: some View {
            
            VStack {
                Image(uiImage: self.inputImage)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    //.overlay(ImageOverlay(), alignment: .top)
     
                Button(action: {
                    self.isShowPhotoLibrary = true
                    self.isDone = false
                    
                }) {
                    HStack {
                        Image(systemName: "photo")
                            .font(.system(size: 20))
     
                        Text("Upload a photo")
                            .font(.headline)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.horizontal)
                }
                Button("Done") {
                    self.showForm = true
                    }
                .foregroundColor(Color.blue)
                .disabled(self.isDone)
                .sheet(isPresented: $showForm) {
                    
                            
                    NavigationView{
                        SecondView(image:self.$inputImage)
                    }.navigationBarTitle("")
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                        .presentationDetents([.fraction(0.4)])
                        .padding(35)
                }
                
            }.sheet(isPresented: $isShowPhotoLibrary) {
                ImagePicker(selectedImage: self.$inputImage,sourceType: .photoLibrary )
                
            }
    }
}

struct SecondView: View {
    @State var question: String = ""
    @State var result: String = ""
    @State private var showAnswer = false
    @State private var disableSubmit = false
    @Binding var image:UIImage
    @State private var isLoading = false
    var body: some View {
        Form{
            
            Section(header: Text("Ask Anything")){
                TextField("Question", text: $question)
            }.padding(5)
                .cornerRadius(20)
            Button(action: {
                Task{
                    self.isLoading = true
                    self.disableSubmit = true
                    printMessagesForUser(question: $question.wrappedValue, img: image){ (output) in
                        //print("Output printing in 73")
                        //print(output)
                        self.result = output
                        self.showAnswer = true
                    }
                }
            }) {
                        Text("Submit Question")
            }.disabled(self.disableSubmit).sheet(isPresented: $showAnswer) {
                        NavigationView{
                            ThirdView(result:$result)
                        }.navigationBarTitle("")
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true)
                            .presentationDetents([.fraction(0.4)])
                        
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.horizontal)
            HStack {
                if isLoading {
                    
                    Text("Please wait while we fetch your answer..").font(.caption2) // your content view
                    Laden.CircleLoadingView( color: .blue , strokeLineWidth: 3)
                } else {
                    Text("")
                }
            }
        }
    }
}
struct ThirdView: View {
    @Binding var result:String
    var body: some View {
        VStack{
            //Text("thirdview")
            Text(result).font(.title).foregroundColor(.primary)
        }
    }
}
func printMessagesForUser(question: String, img: UIImage, completionBlock: @escaping (String) -> Void) -> Void {
            print("Enter flask post!!!!")
    let imageData:NSData = img.pngData()! as NSData
    let strBase64:String = imageData.base64EncodedString(options: [])
//    //print(path.base64EncodedData())
    let json = ["question":question, "image":strBase64 ] as [String : Any]
    //let json = ["question": question]
    //let jsonData =  try JSONSerialization.dataWithJSONObject(attdList, options: .prettyPrinted) // first of all convert json to the data
        
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                //let convertedString = String(data: jsonData, encoding: .utf8)
                let url = NSURL(string: "http://127.0.0.1:5000/replicate")!
                let request = NSMutableURLRequest(url: url as URL)
                request.httpMethod = "POST"
                
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                    if error != nil{
                        print("Error -> \(error)")
                        return
                    }
                    do {
                        let result = try String(data: data!, encoding: String.Encoding.utf8) as String?
                        print("Result -> \(result)")
                        completionBlock(result.unsafelyUnwrapped)
                        
                    } catch {
                        let result = ""
                        print("Error -> \(error)")
                    }
                }
                
                task.resume()
            } catch {
                print(error)
            }
        }



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    
}
