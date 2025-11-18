import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var isbnField: UITextField!
    @IBOutlet weak var coverImageView: UIImageView!

    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    	

    @IBAction func loadButtonPressed(_ sender: Any) {

        guard let isbn = isbnField.text, !isbn.isEmpty else {
            showAlert("Введіть ISBN")
            return
        }
        let urlString = "https://covers.openlibrary.org/b/isbn/\(isbn)-L.jpg"

        guard let url = URL(string: urlString) else {
            showAlert("невірний код книжки")
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {

                DispatchQueue.main.async { [weak self] in
                    self?.imageViewHeightConstraint.constant = image.size.height
                    self?.coverImageView.image = image
                }

            } else {
                DispatchQueue.main.async {
                    self.showAlert("Обкладинку не знайдено")
                }
            }
        }.resume()
    }

    func showAlert(_ text: String) {
            let alert = UIAlertController(
                title: "Помилка",
                message: text,
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "OK", style: .default))

            present(alert, animated: true)
        }
    }
