import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var isbnField: UITextField!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var themeSwitch: UISwitch!
    @IBOutlet weak var fontSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        applySavedSettings()
        loadSavedCover()
        
        themeSwitch.isOn = (UserDefaults.standard.string(forKey: "bgColor") == "yellow")
        fontSwitch.isOn = (UserDefaults.standard.integer(forKey: "fontSize") == 26)
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
                    guard let self = self else { return }

                    self.imageViewHeightConstraint.constant = image.size.height
                    self.coverImageView.image = image

                    self.saveCoverImage(data)
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

    func saveCoverImage(_ data: Data) {
        let url = getDocumentsDirectory().appendingPathComponent("savedCover.jpg")
        try? data.write(to: url)
    }

    func loadSavedCover() {
        let url = getDocumentsDirectory().appendingPathComponent("savedCover.jpg")
        if let data = try? Data(contentsOf: url),
           let image = UIImage(data: data) {
            coverImageView.image = image
            imageViewHeightConstraint.constant = image.size.height
        }
    }

    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    func applySavedSettings() {
        let bg = UserDefaults.standard.string(forKey: "bgColor") ?? "white"
        let fontSize = UserDefaults.standard.integer(forKey: "fontSize")

        view.backgroundColor = (bg == "yellow" ? .yellow : .white)

        let size = fontSize == 0 ? 16 : fontSize
        isbnField.font = UIFont.systemFont(ofSize: CGFloat(size))
        isbnField.textColor = .black
    }

    @IBAction func switchesChanged(_ sender: UISwitch) {
        let bg = themeSwitch.isOn ? "yellow" : "white"
        UserDefaults.standard.set(bg, forKey: "bgColor")

        let size = fontSwitch.isOn ? 26 : 16
        UserDefaults.standard.set(size, forKey: "fontSize")

        applySavedSettings()
    }
}
