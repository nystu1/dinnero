import UIKit

extension UIImage {
    func resize(to targetSize: CGSize) -> UIImage {
        UIGraphicsImageRenderer(size: targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
