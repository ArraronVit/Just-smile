import UIKit

var str = "Hello, playground"

func mostFrequent(array: [String]) -> String? {
   
    var counts = [String: Int]()

    array.forEach { counts[$0] = (counts[$0] ?? 0) + 1 }

    if let (value, _) = counts.max(by: {$0.1 < $1.1}) {
        return value
    }

    return nil
}

if let result = mostFrequent(array: ["sad", "sad", "sad", "neutral", "neutral"]) {
    print("\(result)")
}
