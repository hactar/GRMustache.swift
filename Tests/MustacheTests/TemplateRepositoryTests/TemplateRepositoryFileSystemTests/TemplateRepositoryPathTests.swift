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
import Mustache
import Foundation

class TemplateRepositoryPathTests: XCTestCase {

// GENERATED: allTests required for Swift 3.0
    var allTests : [(String, () throws -> Void)] {
        return [
            ("testTemplateRepositoryWithURL", testTemplateRepositoryWithURL),
            ("testTemplateRepositoryWithURLTemplateExtensionEncoding", testTemplateRepositoryWithURLTemplateExtensionEncoding),
            ("testAbsolutePartialName", testAbsolutePartialName),
            ("testPartialNameCanNotEscapeTemplateRepositoryRootDirectory", testPartialNameCanNotEscapeTemplateRepositoryRootDirectory),
        ]
    }
// END OF GENERATED CODE
    
    func testTemplateRepositoryWithURL() {
        #if os(Linux) // Bundle(for:) is not yet implemented on Linux
            //TODO remove this ifdef once Bundle(for:) is implemented
            // issue https://bugs.swift.org/browse/SR-794
        let testBundle = Bundle(path: ".build/debug/Package.xctest/Contents/Resources")!
        #else
        let testBundle = Bundle(for: type(of: self))
        #endif
        let directoryPath = testBundle.path(forResource: "TemplateRepositoryFileSystemTests_UTF8", ofType: nil)!
        let repo = TemplateRepository(directoryPath: directoryPath)
        var template: Template
        var rendering: String
        
        do {
            try repo.template(named: "notFound")
            XCTAssert(false)
        } catch {
        }
        
        template = try! repo.template(named: "file1")
        rendering = try! template.render()
        XCTAssertEqual(rendering, "é1.mustache\ndir/é1.mustache\ndir/dir/é1.mustache\ndir/dir/é2.mustache\n\n\ndir/é2.mustache\n\n\né2.mustache\n\n")
        
        template = try! repo.template(string: "{{>file1}}")
        rendering = try! template.render()
        XCTAssertEqual(rendering, "é1.mustache\ndir/é1.mustache\ndir/dir/é1.mustache\ndir/dir/é2.mustache\n\n\ndir/é2.mustache\n\n\né2.mustache\n\n")
        
        template = try! repo.template(string: "{{>dir/file1}}")
        rendering = try! template.render()
        XCTAssertEqual(rendering, "dir/é1.mustache\ndir/dir/é1.mustache\ndir/dir/é2.mustache\n\n\ndir/é2.mustache\n\n")
        
        template = try! repo.template(string: "{{>dir/dir/file1}}")
        rendering = try! template.render()
        XCTAssertEqual(rendering, "dir/dir/é1.mustache\ndir/dir/é2.mustache\n\n")
    }
    
    func testTemplateRepositoryWithURLTemplateExtensionEncoding() {
        #if os(Linux) // Bundle(for:) is not yet implemented on Linux
            //TODO remove this ifdef once Bundle(for:) is implemented
            // https://bugs.swift.org/browse/SR-794
        let testBundle = Bundle(path: ".build/debug/Package.xctest/Contents/Resources")!
        #else
        let testBundle = Bundle(for: type(of: self))
        #endif

        var directoryPath: String
        var repo: TemplateRepository
        var template: Template
        var rendering: String
        
        directoryPath = testBundle.path(forResource: "TemplateRepositoryFileSystemTests_UTF8", ofType: nil)!
        repo = TemplateRepository(directoryPath: directoryPath, templateExtension: "mustache", encoding: String.Encoding.utf8)
        template = try! repo.template(named: "file1")
        rendering = try! template.render()
        XCTAssertEqual(rendering, "é1.mustache\ndir/é1.mustache\ndir/dir/é1.mustache\ndir/dir/é2.mustache\n\n\ndir/é2.mustache\n\n\né2.mustache\n\n")
        
        directoryPath = testBundle.path(forResource: "TemplateRepositoryFileSystemTests_UTF8", ofType: nil)!
        repo = TemplateRepository(directoryPath: directoryPath, templateExtension: "txt", encoding: String.Encoding.utf8)
        template = try! repo.template(named: "file1")
        rendering = try! template.render()
        XCTAssertEqual(rendering, "é1.txt\ndir/é1.txt\ndir/dir/é1.txt\ndir/dir/é2.txt\n\n\ndir/é2.txt\n\n\né2.txt\n\n")
        
        directoryPath = testBundle.path(forResource: "TemplateRepositoryFileSystemTests_UTF8", ofType: nil)!
        repo = TemplateRepository(directoryPath: directoryPath, templateExtension: "", encoding: String.Encoding.utf8)
        template = try! repo.template(named: "file1")
        rendering = try! template.render()
        XCTAssertEqual(rendering, "é1\ndir/é1\ndir/dir/é1\ndir/dir/é2\n\n\ndir/é2\n\n\né2\n\n")
        
        directoryPath = testBundle.path(forResource: "TemplateRepositoryFileSystemTests_ISOLatin1", ofType: nil)!
        repo = TemplateRepository(directoryPath: directoryPath, templateExtension: "mustache", encoding: String.Encoding.isoLatin1)
        template = try! repo.template(named: "file1")
        rendering = try! template.render()
        XCTAssertEqual(rendering, "é1.mustache\ndir/é1.mustache\ndir/dir/é1.mustache\ndir/dir/é2.mustache\n\n\ndir/é2.mustache\n\n\né2.mustache\n\n")
        
        directoryPath = testBundle.path(forResource: "TemplateRepositoryFileSystemTests_ISOLatin1", ofType: nil)!
        repo = TemplateRepository(directoryPath: directoryPath, templateExtension: "txt", encoding: String.Encoding.isoLatin1)
        template = try! repo.template(named: "file1")
        rendering = try! template.render()
        XCTAssertEqual(rendering, "é1.txt\ndir/é1.txt\ndir/dir/é1.txt\ndir/dir/é2.txt\n\n\ndir/é2.txt\n\n\né2.txt\n\n")
        
        directoryPath = testBundle.path(forResource: "TemplateRepositoryFileSystemTests_ISOLatin1", ofType: nil)!
        repo = TemplateRepository(directoryPath: directoryPath, templateExtension: "", encoding: String.Encoding.isoLatin1)
        template = try! repo.template(named: "file1")
        rendering = try! template.render()
        XCTAssertEqual(rendering, "é1\ndir/é1\ndir/dir/é1\ndir/dir/é2\n\n\ndir/é2\n\n\né2\n\n")
    }
    
    func testAbsolutePartialName() {
        #if os(Linux) // Bundle(for:) is not yet implemented on Linux
            //TODO remove this ifdef once Bundle(for:) is implemented
            // https://bugs.swift.org/browse/SR-794
            let testBundle = Bundle(path: ".build/debug/Package.xctest/Contents/Resources")!
        #else
            let testBundle = Bundle(for: type(of: self))
        #endif
        let directoryPath = testBundle.path(forResource: "TemplateRepositoryFileSystemTests", ofType: nil)!
        let repo = TemplateRepository(directoryPath: directoryPath)
        let template = try! repo.template(named: "base")
        let rendering = try! template.render()
        XCTAssertEqual(rendering, "success")
    }
    
    func testPartialNameCanNotEscapeTemplateRepositoryRootDirectory() {
        #if os(Linux) // Bundle(for:) is not yet implemented on Linux
            //TODO remove this ifdef once Bundle(for:) is implemented
            // https://bugs.swift.org/browse/SR-794
            let testBundle = Bundle(path: ".build/debug/Package.xctest/Contents/Resources")!
        #else
            let testBundle = Bundle(for: type(of: self))
        #endif

        let directoryPath = testBundle.path(forResource: "TemplateRepositoryFileSystemTests", ofType: nil)!
        let repo = TemplateRepository(directoryPath: directoryPath.bridge().appendingPathComponent("partials"))
        
        let template = try! repo.template(named: "partial2")
        let rendering = try! template.render()
        XCTAssertEqual(rendering, "success")
        
        do {
            try repo.template(named: "up")
            XCTFail("Expected MustacheError")
        } catch let error as MustacheError {
            XCTAssertEqual(error.kind, MustacheError.Kind.TemplateNotFound)
        } catch {
            XCTFail("Expected MustacheError")
        }
    }
}