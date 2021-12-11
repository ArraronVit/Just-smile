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


final class ViewController: UIViewController {
    private var isFrontMode = true {
        willSet {
            toggleCamera()
        }
    }
    
    private var observationStarted: Bool = false
    private var realtimeMode: Bool = false
    private var bestPredict: String = ""
    private var observedData: [String] = []
    private var observedConfidence: [Float] = []
    
    private var captureSession: AVCaptureSession?
    
    private var frontCamera: AVCaptureDevice? {
        AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
    }
    
    private var backCamera: AVCaptureDevice? {
        AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
    }
    
    @IBOutlet private weak var emotionImage: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var toggleCameraButton: UIButton!
    @IBOutlet private weak var takePhotoButton: UIButton!
    @IBOutlet private weak var cameraView: UIView!
    @IBOutlet private weak var predictLabel: RoundedLabel!
    @IBOutlet private weak var realtimeButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let captureDevice = frontCamera else { return }
        
        setupCaptureSession(captureDevice: captureDevice)
    }
}

private extension ViewController {
    func setupCaptureSession(captureDevice: AVCaptureDevice) {
        let captureSession = AVCaptureSession()
        captureSession.beginConfiguration()
        
        if captureSession.canSetSessionPreset(.photo) {
            captureSession.sessionPreset = .photo
        }
        
        setCaptureSessionInput(captureDevice)
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(
            self,
            queue: DispatchQueue(label: Constants.videoQueueName)
        )
        
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.bounds
        
        captureSession.commitConfiguration()
        captureSession.startRunning()
        
        self.captureSession = captureSession
    }
    
    func setCaptureSessionInput(_ device: AVCaptureDevice) {
        guard
            let captureSession = captureSession,
            let input = try? AVCaptureDeviceInput(device: device)
        else {
            return
        }
        
        captureSession.inputs.forEach { captureSession.removeInput($0) }
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
    }
    
    func layoutPredict() {
        guard
            let predictRaw = observedData.mode,
            let predict = Predict(rawValue: predictRaw)
        else {
            return
        }
        
        switch predict {
        case .happy:
            descriptionLabel.text = AdviceDatasource.getHappyAdvice()
        case .sad:
            descriptionLabel.text = AdviceDatasource.getSadAdvice()
        case .angry:
            descriptionLabel.text = AdviceDatasource.getAngryAdvice()
        case .surprise:
            descriptionLabel.text = AdviceDatasource.getSurpriseAdvice()
        case .neutral:
            descriptionLabel.text = AdviceDatasource.getNeutralAdvice()
        case .fear:
            descriptionLabel.text = AdviceDatasource.getFearAdvice()
        }
        
        let averageConfidence = Int(observedConfidence.average * 2 * 100)
        
        emotionImage.image = predict.emotionImage
        predictLabel.text = predict.printable(averageConfidence)
        observedData = []
        observedConfidence = []
        observationStarted = false
        takePhotoButton.setTitle("begin", for: .normal)
    }
    
    func toggleCamera() {
        guard let device = isFrontMode ? backCamera : frontCamera else { return }
        
        captureSession?.beginConfiguration()
        setCaptureSessionInput(device)
        captureSession?.commitConfiguration()
    }
    
}

private extension ViewController {
    @IBAction func toggleCameraButtonTapped(_ sender: Any) {
        isFrontMode.toggle()
    }
    
    @IBAction func takePhotoButtonTapped(_ sender: Any) {
        realtimeMode = false
        observationStarted = true
        realtimeButton.backgroundColor = .clear
        predictLabel.text = ""
        takePhotoButton.setTitle("please wait...", for: .normal)
    }
    
    @IBAction func realtimeButtonTapped(_ sender: Any) {
        if !observationStarted {
            realtimeMode.toggle()
        }
        realtimeButton.backgroundColor = realtimeMode ? .systemTeal : .clear
    }
}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        guard
            let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
            let model = try? VNCoreMLModel(for: EmotionClassifier(configuration: MLModelConfiguration()).model)
        else {
            return
        }
        
        let request = VNCoreMLRequest(model: model) { finishedReq, err in
            guard
                let results = finishedReq.results as? [VNClassificationObservation],
                let firstObservation = results.first
            else {
                return
            }

            DispatchQueue.main.async {
                if self.observationStarted {
                    self.observedData.append(firstObservation.identifier)
                    self.observedConfidence.append(firstObservation.confidence)
                    
                    self.realtimeMode = false
                    
                    if self.observedData.count >= 50 {
                        self.layoutPredict()
                    }
                } else if self.realtimeMode {
                    self.predictLabel.text = "\(firstObservation.identifier) with \(Int(firstObservation.confidence * 100))% confidence"
                }
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}

private extension ViewController {
    enum Constants {
        static let videoQueueName = "videoQueue"
    }
    
    enum Predict: String {
        case happy
        case sad
        case angry
        case surprise
        case neutral
        case fear
        
        var emotionImage: UIImage? {
            UIImage(imageLiteralResourceName: "\(rawValue)")
        }
        
        func printable(_ confidence: Int) -> String {
            "\(rawValue) with \(confidence)% confidence"
        }
    }
    
}
