//
//  ScanQRCodeVC.swift
//  KabinetZhitelya
//
//  Created by Andreas on 13.03.2021.
//  Copyright © 2021 user191208. All rights reserved.
//

import UIKit
import AVFoundation

class ScanQRCodeVC: UIViewController {
    
    var video = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession()
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupVideo()
        startRunning()
    }
    
    func setupVideo() {
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        } catch {
            fatalError(error.localizedDescription)
        }
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]

        video = AVCaptureVideoPreviewLayer(session: session)
        
        video.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        video.videoGravity = AVLayerVideoGravity.resizeAspectFill
    }
    
    func startRunning() {
        view.layer.insertSublayer(video, at: 0)
        session.startRunning()
    }
}

// MARK: - AVCapture Metadata Output Objects Delegate

extension ScanQRCodeVC: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count > 0 else { return }
        session.stopRunning()
        activityIndicator.startAnimating()
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if object.type == AVMetadataObject.ObjectType.qr {
                NetworkManager.linkFromQRCode(QRCode: object.stringValue ?? "") { (bankUrl) in
                    if let url = URL(string: bankUrl as! String) {
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.open(url)
                        self.performSegue(withIdentifier: "unwindSegueToSignInVC", sender: nil)
                    }
                } completion404: {
                    self.showAlert(title: "По данному QR коду невозможно произвести оплату", message: nil) {
                        self.activityIndicator.stopAnimating()
                        self.performSegue(withIdentifier: "unwindSegueToSignInVC", sender: nil)
                    }
                }
            }
        }
    }
}
