//
//  PostViewController.swift
//  BeReal
//

import UIKit
import PhotosUI
import ParseSwift
import CoreLocation
import ImageIO

class PostViewController: UIViewController {

    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var previewImageView: UIImageView!

    private var pickedImage: UIImage?
    private var locationNameForPost: String?
    private var photoLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onPickedImageTapped(_ sender: UIBarButtonItem) {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.preferredAssetRepresentationMode = .current
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self

        present(picker, animated: true)
    }

    @IBAction func onShareTapped(_ sender: Any) {
        view.endEditing(true)

        guard let image = pickedImage,
              let imageData = image.jpegData(compressionQuality: 0.1) else {
            return
        }

        let imageFile = ParseFile(name: "image.jpg", data: imageData)

        var post = Post()
        post.imageFile = imageFile
        post.caption = captionTextField.text
        post.user = User.current
        post.locationName = locationNameForPost
        
        if let loc = photoLocation {
            post.location = try? ParseGeoPoint(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
        }
        
        post.save { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let post):
                    print("✅ Post Saved! \(post)")
                    
                    if var currentUser = User.current {
                        currentUser.lastPostedDate = Date()
                        currentUser.save { [weak self] result in
                            switch result {
                            case .success(let user):
                                print("✅ User Saved! \(user)")
                                DispatchQueue.main.async {
                                    // Return to previous view controller
                                    self?.navigationController?.popViewController(animated: true)
                                }

                            case .failure(let error):
                                self?.showAlert(description: error.localizedDescription)
                            }
                        }
                    }
                case .failure(let error):
                    self?.showAlert(description: error.localizedDescription)
                }
            }
        }
    }

    @IBAction func onTakePhotoTapped(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("❌📷 Camera not available")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }

    @IBAction func onViewTapped(_ sender: Any) {
        // Dismiss keyboard
        view.endEditing(true)
    }
}

extension PostViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in

            guard let image = object as? UIImage else {
                self?.showAlert()
                return
            }

            if let error = error {
                self?.showAlert(description: error.localizedDescription)
                return
            } else {

                DispatchQueue.main.async {

                    self?.previewImageView.image = image
                    self?.pickedImage = image
                }
            }
            if provider.hasItemConformingToTypeIdentifier("public.image") {
                provider.loadFileRepresentation(forTypeIdentifier: "public.image"){ [weak self] url, error in
                    guard let url = url
                    else { return }
                    self?.extractMetadataFromURL(url)
                }
            }
        }
    }
}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
            guard let image = info[.editedImage] as? UIImage else {
                print("❌📷 Unable to get image")
                return
            }

            previewImageView.image = image
            pickedImage = image
        
        if let metadata = info[.mediaMetadata] as? [String: Any],
           let gps = metadata["{GPS}"] as? [String: Any] {
            extractLocationFromGPS(gps)
        }
    }
}

extension PostViewController {
    
    func extractLocationFromGPS(_ gps: [String: Any]) {
        guard let latitude = gps["Latitude"] as? Double,
              let latitudeRef = gps["LatitudeRef"] as? String,
              let longitude = gps["Longitude"] as? Double,
              let longitudeRef = gps["LongitudeRef"] as? String else { return }
        
        let lat = latitudeRef == "S" ? -latitude : latitude
        let lon = longitudeRef == "W" ? -longitude : longitude
        
        photoLocation = CLLocation(latitude: lat, longitude: lon)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(photoLocation!) { [weak self] placemarks, error in
            if let placemark = placemarks?.first {
                let city = placemark.locality ?? ""
                let state = placemark.administrativeArea ?? ""
                self?.locationNameForPost = "\(city), \(state)"
            }
        }
    }
    
    func extractMetadataFromURL(_ url: URL) {
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
              let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String: Any],
              let gps = properties[kCGImagePropertyGPSDictionary as String] as? [String: Any] else { return }
        
        guard let latitude = gps[kCGImagePropertyGPSLatitude as String] as? Double,
              let latitudeRef = gps[kCGImagePropertyGPSLatitudeRef as String] as? String,
              let longitude = gps[kCGImagePropertyGPSLongitude as String] as? Double,
              let longitudeRef = gps[kCGImagePropertyGPSLongitudeRef as String] as? String else { return }
        
        let lat = latitudeRef == "S" ? -latitude : latitude
        let lon = longitudeRef == "W" ? -longitude : longitude
        
        photoLocation = CLLocation(latitude: lat, longitude: lon)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(photoLocation!) { [weak self] placemarks, error in
            if let placemark = placemarks?.first {
                let city = placemark.locality ?? ""
                let state = placemark.administrativeArea ?? ""
                self?.locationNameForPost = "\(city), \(state)"
            }
        }
    }
}

