
// The MIT License
//
// Copyright (c) 2015 Gwendal Roué
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import XCTest
@testable import Mustache
import Foundation
import SwiftyJSON

extension JSON: MustacheBoxable {
    public var mustacheBox: MustacheBox {
        if let bool = self.bool {
            return Box(bool)
        }
        if let int = self.int {
            return Box(int)
        }
        if let string = self.string {
            return Box(string)
        }
        if let array = self.array {
            return Box(array)
        }
        if let dictionary = self.dictionary {
            return Box(dictionary)
        }
        if let nsnull = self.object as? NSNull {
            return Box(nsnull)
        }
        return Box()
    }
}

class SuiteTestCase: XCTestCase {

// GENERATED: allTests required for Swift 3.0
    var allTests : [(String, () throws -> Void)] {
        return [
        ]
    }
// END OF GENERATED CODE

    func runTests(fromResource name: String, directory: String) {
        let testBundle = FoundationAdapter.getBundle(for: type(of: self))

        guard let path = testBundle.path(forResource: name, ofType: nil, inDirectory: directory) else {
            print("bundle resource path is \(String(describing: testBundle.resourcePath))")
            XCTFail("No such test suite \(directory)/\(name)")
            return
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let testSuite = JSON(data: data)

            for (_, testDictionaryJSON) in testSuite["tests"] {
                let test = Test(path: path, dictionary: testDictionaryJSON.dictionaryValue)
                test.run()
            }
        } catch {
             XCTFail("Error reading data from\(path): \(error)")
             return
         }
    }

    class Test {
        let path: String
        let dictionary: [String: JSON]

        init(path: String, dictionary: [String: JSON]) {
            self.path = path
            self.dictionary = dictionary
        }

        func run() {
            let name = dictionary["name"]!.stringValue
            NSLog("Run test \(name)")
            for template in templates {

                // Standard Library
                template.registerInBaseContext("each", Box(StandardLibrary.each))
                template.registerInBaseContext("zip", Box(StandardLibrary.zip))
                template.registerInBaseContext("localize", Box(StandardLibrary.Localizer(bundle: nil, table: nil)))
                template.registerInBaseContext("HTMLEscape", Box(StandardLibrary.HTMLEscape))
                template.registerInBaseContext("URLEscape", Box(StandardLibrary.URLEscape))
                template.registerInBaseContext("javascriptEscape", Box(StandardLibrary.javascriptEscape))

                // Support for filters.json
                template.registerInBaseContext("capitalized", Box(Filter({ (string: String?) -> MustacheBox in
                    return Box(string?.capitalized)
                })))

                testRendering(template)
            }
        }

        //

        var description: String { return "test `\(name)` at \(path)" }
        var name: String { return dictionary["name"]!.stringValue }
        var partialsDictionary: [String: String]? {
            var resultDictionary = [String: String]()
            if let partialsDictionary = dictionary["partials"]?.dictionaryValue {
                for (key, value) in partialsDictionary {
                    resultDictionary[key] = value.stringValue
                }
                return resultDictionary
            }
            return nil
        }
        var templateString: String? { return dictionary["template"]?.string }
        var templateName: String? { return dictionary["template_name"]?.string }
        var renderedValue: MustacheBox { return Box(dictionary["data"]) }
        var expectedRendering: String? { return dictionary["expected"]?.string }
        var expectedError: String? { return dictionary["expected_error"]?.string }

        var templates: [Template] {
            if let partialsDictionary = partialsDictionary {
                if let templateName = templateName {
                    var templates: [Template] = []
                    let templateURL = URL(string: templateName)
                    let templateExtension = templateURL?.pathExtension ?? ""
                    for (directoryPath, encoding) in pathsAndEncodingsToPartials(partialsDictionary) {
                        let templateNameWithoutPathExtension = (templateURL?.deletingPathExtension())?.absoluteString ?? templateName
                        do {
                            let template = try TemplateRepository(directoryPath: directoryPath, templateExtension: templateExtension, encoding: encoding).template(named: templateNameWithoutPathExtension)
                            templates.append(template)
                        } catch {
                            testError(error, replayOnFailure: {
                                do {
                                    let _ = try TemplateRepository(directoryPath: directoryPath, templateExtension: templateExtension, encoding: encoding).template(named: templateNameWithoutPathExtension)
                                } catch {
                                    // ignore error on replay
                                }
                            })
                        }
                    }
                    return templates
                } else if let templateString = templateString {
                    var templates: [Template] = []
                    for (directoryPath, encoding) in pathsAndEncodingsToPartials(partialsDictionary) {
                        do {
                            let template = try TemplateRepository(directoryPath: directoryPath, templateExtension: "", encoding: encoding).template(string: templateString)
                            templates.append(template)
                        } catch {
                            testError(error, replayOnFailure: {
                                do {
                                    let _ = try TemplateRepository(directoryPath: directoryPath, templateExtension: "", encoding: encoding).template(string: templateString)
                                } catch {
                                    // ignore error on replay
                                }
                            })
                        }

                        do {
                            let template = try TemplateRepository(baseURL: URL(fileURLWithPath: directoryPath), templateExtension: "", encoding: encoding).template(string: templateString)
                            templates.append(template)
                        } catch {
                            testError(error, replayOnFailure: {
                                do {
                                    let _ = try TemplateRepository(baseURL: URL(fileURLWithPath: directoryPath), templateExtension: "", encoding: encoding).template(string: templateString)
                                } catch {
                                    // ignore error on replay
                                }
                            })
                        }
                    }
                    return templates
                } else {
                    XCTFail("Missing `template` and `template_name` in \(description)")
                    return []
                }
            } else {
                if let _ = templateName {
                    XCTFail("Missing `partials` in \(description)")
                    return []
                } else if let templateString = templateString {
                    var templates: [Template] = []
                    do {
                        let template = try TemplateRepository().template(string: templateString)
                        templates.append(template)
                    } catch {
                        testError(error, replayOnFailure: {
                            do {
                                let _ = try TemplateRepository().template(string: templateString)
                            } catch {
                                // ignore error on replay
                            }
                        })
                    }
                    return templates
                } else {
                    XCTFail("Missing `template` and `template_name` in \(description)")
                    return []
                }
            }
        }

        func testRendering(_ template: Template) {
            do {
                let rendering = try template.render(with: renderedValue)
                if let expectedRendering = expectedRendering {
                    if expectedRendering != rendering {
                        XCTAssertEqual(rendering, expectedRendering, "Unexpected rendering of \(description)")
                    }
                }
                testSuccess(replayOnFailure: {
                    do {
                        let _ = try template.render(with: self.renderedValue)
                    } catch {
                        // ignore error on replay
                    }
                })
            } catch {
                testError(error, replayOnFailure: {
                    do {
                        let _ = try template.render(with: self.renderedValue)
                    } catch {
                        // ignore error on replay
                    }
                })
            }
        }

        func testError(_ error: Error, replayOnFailure replayBlock: ()->()) {
            if let expectedError = expectedError {
                do {
                    let reg = try FoundationAdapter.RegularExpression(pattern: expectedError, options: FoundationAdapter.RegularExpression.Options(rawValue: 0))
                    let errorMessage = "\(error)"
                    let matches = reg.matches(in: errorMessage, options: FoundationAdapter.NSMatchingOptions(rawValue: 0), range:NSMakeRange(0, errorMessage._bridgeToObjectiveC().length))
                    if matches.count == 0 {
                        XCTFail("`\(errorMessage)` does not match /\(expectedError)/ in \(description)")
                        replayBlock()
                    }
                } catch {
                    XCTFail("Invalid expected_error in \(description): \(error)")
                    replayBlock()
                }
            } else {
                #if os(Linux) //Due to issue https://bugs.swift.org/browse/SR-585
                     //TODO remove once the issue is resolved
                     XCTFail("Unexpected error in \(description): unknown error")
                #else
                     XCTFail("Unexpected error in \(description): \(error)")
                #endif

                replayBlock()
            }
        }

        func testSuccess(replayOnFailure replayBlock: ()->()) {
            if expectedError != nil {
                XCTFail("Unexpected success in \(description)")
                replayBlock()
            }
        }

        func pathsAndEncodingsToPartials(_ partialsDictionary: [String: String]) -> [(String, String.Encoding)] {
            var templatesPaths: [(String, String.Encoding)] = []

            let fm = FileManager.`default`
            let encodings: [String.Encoding] = [String.Encoding.utf8, String.Encoding.utf16]
            for encoding in encodings {
                let templatesURL = (URL(string: NSTemporaryDirectory())?.appendingPathComponent("GRMustacheTest"))?.appendingPathComponent("encoding_\(encoding.rawValue)")
                let templatesPath = templatesURL?.path ?? "."
                if fm.fileExists(atPath: templatesPath) {
                    try! fm.removeItem(atPath: templatesPath)
                }
                for (partialName, partialString) in partialsDictionary {
                    let partialURL = templatesURL?.appendingPathComponent(partialName)
                    let partialPath = partialURL?.path ?? "."
                    do {
                        try fm.createDirectory(atPath: (partialURL?.deletingLastPathComponent())?.path ?? ".", withIntermediateDirectories: true, attributes: nil)
                        if !fm.createFile(atPath: partialPath, contents: partialString.data(using: encoding, allowLossyConversion: false), attributes: nil) {
                            XCTFail("Could not save template in \(description)")
                            return []
                        }
                    } catch {
                        XCTFail("Could not save template in \(description): \(error)")
                        return []
                    }
                }

                templatesPaths.append((templatesPath, encoding))
            }

            return templatesPaths
        }
    }
}
