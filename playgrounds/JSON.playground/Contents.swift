import UIKit

// get the file path for the file "test.json" in the playground bundle
let filePath = Bundle.main.path(forResource: "person", ofType: "json")

// get the contentData
let jsonData = FileManager.default.contents(atPath: filePath!)

let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .iso8601

let person = try decoder.decode(Person.self, from: jsonData!)
print(person.age)
