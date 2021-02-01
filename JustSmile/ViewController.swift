//
//  ViewController.swift
//  CoreML_test
//
//  Created by Vitaly Kozlov on 23.01.2021.
//

import UIKit
import AVKit
import Vision
import CoreML


class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate{

    var isFrontMode: Bool = true
    var observationStarted: Bool = false
    let videoQueue = DispatchQueue(label: "videoQueue")
    let captureSession = AVCaptureSession()
    var observedData:[String] = []
    
    
    @IBOutlet weak var emotionImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var toggleCameraButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    
    @IBAction func toggleCameraButtonTapped(_ sender: Any) {
        
        if isFrontMode {
            guard let captureDevice = getBackCamera() else { return }
            setupCaptureSession(captureDevice: captureDevice, captureSession: captureSession)
        } else {
            guard let captureDevice = getFrontCamera() else { return }
            setupCaptureSession(captureDevice: captureDevice, captureSession: captureSession)
        }
        isFrontMode.toggle()
    }
    
    @IBAction func takePhotoButtonTapped(_ sender: Any) {
        observationStarted = true
        takePhotoButton.setTitle("please wait...", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        captureSession.sessionPreset = .photo
        guard let captureDevice = getFrontCamera() else { return }
        setupCaptureSession(captureDevice: captureDevice, captureSession: captureSession)
    }


    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        print("Camera was able capture a frame: ", Date())
       
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let model = try? VNCoreMLModel(for: EmotionClassifier(configuration: MLModelConfiguration()).model) else { return }
        
        let request = VNCoreMLRequest(model: model) {
            (finishedReq, err) in
            
//            print(finishedReq.results)
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            guard let firstObservation = results.first else { return }
            
            
            print(firstObservation.identifier, firstObservation.confidence)
            
            DispatchQueue.main.async { [self] in
                if observationStarted {
                    observedData.append(firstObservation.identifier)

                    if observedData.count >= 50 {
                        if let predict = findBestPredict(data: observedData) {
                            print("best predict: \(predict)")
                            switch predict {
                            
                            case "happy":
                                descriptionLabel.text = AdviceDatasource.getHappyAdvice()
                            case "sad":
                                descriptionLabel.text = AdviceDatasource.getSadAdvice()
                            case "angry":
                                descriptionLabel.text = AdviceDatasource.getAngryAdvice()
                            case "surprise":
                                descriptionLabel.text = AdviceDatasource.getSurpriseAdvice()
                            case "neutral":
                                descriptionLabel.text = AdviceDatasource.getNeutralAdvice()
                            case "fear":
                                descriptionLabel.text = AdviceDatasource.getFearAdvice()
                        
                            default:
                                descriptionLabel.text = AdviceDatasource.getNeutralAdvice()
                            }
                            
//                            descriptionLabel.text = predict
                            emotionImage.image = UIImage(imageLiteralResourceName: "\(predict)")
                            observedData = []
                            observationStarted = false
                            takePhotoButton.setTitle("begin", for: .normal)
                            
                        }
                    }
                }
//                if(firstObservation.confidence > 0.0) {
//                    descriptionLabel.text = "\(firstObservation.identifier)"
//                }
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        
    }
    
    func getFrontCamera() -> AVCaptureDevice?{
        
        return AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
    }

    
    func getBackCamera() -> AVCaptureDevice? {
        
        return AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
    }
    
    func setupCaptureSession(captureDevice: AVCaptureDevice, captureSession: AVCaptureSession) {
        
//        stopSession()
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        
        
        captureSession.addInput(input)
        captureSession.startRunning()
//        view.layer.sublayers?.removeLast()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        previewLayer.videoGravity = .resizeAspect
//        previewLayer.connection?.videoOrientation = .portrait
//        cameraView.layer.addSublayer(previewLayer)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: videoQueue)
        captureSession.addOutput(dataOutput)
    }
    
    func findBestPredict(data: [String]) -> String? {
       
        var counts = [String: Int]()

        data.forEach { counts[$0] = (counts[$0] ?? 0) + 1 }

        if let (value, _) = counts.max(by: {$0.1 < $1.1}) {
            return value
        }

        return nil
    }
    
}


