//
//  ContentView.swift
//  SkinDiseases
//
//  Created by Ankita Chatterjee on 3/7/22.
//

import SwiftUI
import Alamofire
import SwiftyJSON

let uploadURL="https://askai.aiclub.world/68151504-1263-47eb-ac69-d67265ce28de"


let diagText=["psoriasis":"Cute dog","eczema":"Nice cat"]
let diagImage=["psoriasis":"image_xray","eczema":"image_xray"]
let diagPara=["psoriasis":paraDogs,"eczema":paraCats]

let paraEmpty=Text("")
let paraDogs=Text("**The dog or domestic dog (Canis familiaris or Canis lupus familiaris) is a domesticated descendant of the wolf which is characterized by an upturning tail. The dog is derived from an ancient, extinct wolf, and the modern wolf is the dog's nearest living relative. The dog was the first species to be domesticated, by hunter–gatherers over 15,000 years ago, before the development of agriculture.**")
let paraCats=Text("The **cat** (Felis catus) is a domestic species of a small carnivorous mammal. It is the only domesticated species in the family Felidae and is often referred to as the domestic cat to distinguish it from the wild members of the family. A cat can either be a house cat, a farm cat or a feral cat; the latter ranges freely and avoids human contact. Domestic cats are valued by humans for companionship and their ability to kill rodents. About 60 cat breeds are recognized by various cat registries.")

struct CallAIView: View {
    @State var aiPrediction = ""
    
    @State var diagnosisName = ""
    @State var diagnosisPara = paraEmpty
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage? = UIImage(named: "download")
    @State private var showInputImage=true
    @State private var showDiagText=false
    @State private var showDiagImage=false
    @State private var showDiagPara=false
    @State var buttonMessage="What is this?"
    
    
    var body: some View {
        HStack {
            VStack (alignment: .center, spacing: 2){
                AppName()
                if showInputImage {
                    ShowImage()
                }
                if showDiagText {
                    DiagnosisText()
                }
                if showDiagImage {
                    DiagnosisImage()
                }
                if showDiagPara {
                    DiagnosisPara()
                }
                MyButton()

            }
            .font(.title)
        }.sheet(isPresented: $showingImagePicker, onDismiss: processImage) {
            ImagePicker(image: self.$inputImage)
        }.fixedSize(horizontal: false, vertical: true)
    }
    
    func AppName() -> some View {
        Text("My Doctor")
            .font(.system(.largeTitle, design: .rounded))
            .fontWeight(.bold)
    }
    
    func ShowImage() -> some View {
        Image(uiImage: inputImage!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxHeight: 400)
            
    }
    
    func DiagnosisText() -> some View {
        Text(diagnosisName)
            .font(.system(size: 30))
    }
    
    func DiagnosisImage() -> some View {
        Image(diagImage[aiPrediction]!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxHeight: 200)
    }
    
    func DiagnosisPara() -> some View {
        let a = diagnosisPara.font(.system(size: 20))
        return a
    }
    
    func MyButton() -> some View {
        Button(buttonMessage){
            self.buttonPressed()
        }
        .padding(.all, 14.0)
        .foregroundColor(.white)
        .background(Color.green)
        .cornerRadius(10)
    }
    
    
    
    func buttonPressed() {
        print("Button pressed")
        self.showingImagePicker = true
        self.showDiagText=true
        self.showDiagImage=false
        self.showDiagPara=true
    }
    
    func processImage() {
        self.showingImagePicker = false
        self.diagnosisName="Checking..."
        guard let inputImage = inputImage else {return}
        print("Processing image due to Button press")
        let imageJPG=inputImage.jpegData(compressionQuality: 0.0034)!
        let imageB64 = Data(imageJPG).base64EncodedData()
        
        
        AF.upload(imageB64, to: uploadURL).responseJSON { response in
            
            debugPrint(response)
            switch response.result {
            case .success(let responseJsonStr):
                print("\n\n Success value and JSON: \(responseJsonStr)")
                let myJson = JSON(responseJsonStr)
                let predictedValue = myJson["predicted_label"].string
                let labelMapping = myJson["label_mapping"]
                let score = myJson["score"]
                print("labelMapping = \(labelMapping), score = \(score)")
                self.processResponse(predictedValue)
            case .failure(let error):
                print("\n\n Request failed with error: \(error)")
            }
        }
    }
    
    func processResponse(_ r:String?) {
        print("Saw predicted value \(String(describing: r))")
        
        let predictionMessage = r!
            self.aiPrediction=predictionMessage
        self.diagnosisName=diagText[predictionMessage]!
        self.diagnosisPara=diagPara[predictionMessage]!
        self.showDiagText=true
        self.showDiagImage=false
        self.showDiagPara=true
        self.buttonMessage="Check another"
        
    }
}

struct CallAIView_Previews: PreviewProvider {
    static var previews: some View {
        CallAIView()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
