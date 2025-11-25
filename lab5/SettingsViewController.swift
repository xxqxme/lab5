import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var colorSegment: UISegmentedControl!
    @IBOutlet weak var fontSegment: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        let bg = UserDefaults.standard.string(forKey: "bgColor") ?? "white"
        colorSegment.selectedSegmentIndex = (bg == "white" ? 0 : 1)

        let font = UserDefaults.standard.integer(forKey: "fontSize")
        fontSegment.selectedSegmentIndex = (font == 16 ? 0 : 1)
    }

    @IBAction func saveButtonPressed(_ sender: Any) {

        let bgColor = (colorSegment.selectedSegmentIndex == 0 ? "white" : "black")
        UserDefaults.standard.set(bgColor, forKey: "bgColor")

        let size = (fontSegment.selectedSegmentIndex == 0 ? 16 : 26)
        UserDefaults.standard.set(size, forKey: "fontSize")


        navigationController?.popViewController(animated: true)
    }
}
