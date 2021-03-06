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

class RenderFunctionTests: XCTestCase {

    // allTests required for Swift 3.0
    static var allTests : [(String, (RenderFunctionTests) -> () throws -> Void)] {
        return [
            ("testRenderFunctionInVariableTag", testRenderFunctionInVariableTag),
            ("testRenderFunctionInSectionTag", testRenderFunctionInSectionTag),
            ("testRenderFunctionInInvertedSectionTag", testRenderFunctionInInvertedSectionTag),
            ("testRenderFunctionHTMLRenderingOfEscapedVariableTag", testRenderFunctionHTMLRenderingOfEscapedVariableTag),
            ("testRenderFunctionHTMLRenderingOfUnescapedVariableTag", testRenderFunctionHTMLRenderingOfUnescapedVariableTag),
            ("testRenderFunctionTextRenderingOfEscapedVariableTag", testRenderFunctionTextRenderingOfEscapedVariableTag),
            ("testRenderFunctionTextRenderingOfUnescapedVariableTag", testRenderFunctionTextRenderingOfUnescapedVariableTag),
            ("testRenderFunctionHTMLRenderingOfSectionTag", testRenderFunctionHTMLRenderingOfSectionTag),
            ("testRenderFunctionTextRenderingOfSectionTag", testRenderFunctionTextRenderingOfSectionTag),
            ("testRenderFunctionCanThrowCustomErrorFromVariableTag", testRenderFunctionCanThrowCustomErrorFromVariableTag),
            ("testRenderFunctionCanThrowCustomErrorFromSectionTag", testRenderFunctionCanThrowCustomErrorFromSectionTag),
            ("testRenderFunctionCanAccessVariableTagType", testRenderFunctionCanAccessVariableTagType),
            ("testRenderFunctionCanAccessSectionTagType", testRenderFunctionCanAccessSectionTagType),
            ("testRenderFunctionCanAccessInnerTemplateStringFromSectionTag", testRenderFunctionCanAccessInnerTemplateStringFromSectionTag),
            ("testRenderFunctionCanAccessInnerTemplateStringFromVariableTag", testRenderFunctionCanAccessInnerTemplateStringFromVariableTag),
            ("testRenderFunctionCanAccessRenderedContentFromSectionTag", testRenderFunctionCanAccessRenderedContentFromSectionTag),
            ("testRenderFunctionCanAccessRenderedContentFromEscapedVariableTag", testRenderFunctionCanAccessRenderedContentFromEscapedVariableTag),
            ("testRenderFunctionCanAccessRenderedContentFromUnescapedVariableTag", testRenderFunctionCanAccessRenderedContentFromUnescapedVariableTag),
            ("testRenderFunctionCanRenderCurrentContextInAnotherTemplateFromVariableTag", testRenderFunctionCanRenderCurrentContextInAnotherTemplateFromVariableTag),
            ("testRenderFunctionCanRenderCurrentContextInAnotherTemplateFromSectionTag", testRenderFunctionCanRenderCurrentContextInAnotherTemplateFromSectionTag),
            ("testRenderFunctionDoesNotAutomaticallyEntersVariableContextStack", testRenderFunctionDoesNotAutomaticallyEntersVariableContextStack),
            ("testRenderFunctionDoesNotAutomaticallyEntersSectionContextStack", testRenderFunctionDoesNotAutomaticallyEntersSectionContextStack),
            ("testRenderFunctionCanExtendValueContextStackInVariableTag", testRenderFunctionCanExtendValueContextStackInVariableTag),
            ("testRenderFunctionCanExtendValueContextStackInSectionTag", testRenderFunctionCanExtendValueContextStackInSectionTag),
            ("testRenderFunctionCanExtendWillRenderStackInVariableTag", testRenderFunctionCanExtendWillRenderStackInVariableTag),
            ("testRenderFunctionCanExtendWillRenderStackInSectionTag", testRenderFunctionCanExtendWillRenderStackInSectionTag),
            ("testRenderFunctionTriggersWillRenderFunctions", testRenderFunctionTriggersWillRenderFunctions),
            ("testRenderFunctionTriggersWillRenderFunctionsInAnotherTemplateFromVariableTag", testRenderFunctionTriggersWillRenderFunctionsInAnotherTemplateFromVariableTag),
            ("testRenderFunctionTriggersWillRenderFunctionsInAnotherTemplateFromSectionTag", testRenderFunctionTriggersWillRenderFunctionsInAnotherTemplateFromSectionTag),
            ("testArrayOfRenderFunctionsInSectionTag", testArrayOfRenderFunctionsInSectionTag),
            ("testArrayOfRenderFunctionsInEscapedVariableTag", testArrayOfRenderFunctionsInEscapedVariableTag),
            ("testArrayOfHTMLRenderFunctionsInEscapedVariableTag", testArrayOfHTMLRenderFunctionsInEscapedVariableTag),
            ("testArrayOfHTMLRenderFunctionsInUnescapedVariableTag", testArrayOfHTMLRenderFunctionsInUnescapedVariableTag),
            ("testArrayOfTextRenderFunctionsInEscapedVariableTag", testArrayOfTextRenderFunctionsInEscapedVariableTag),
            ("testArrayOfTextRenderFunctionsInUnescapedVariableTag", testArrayOfTextRenderFunctionsInUnescapedVariableTag),
            ("testArrayOfInconsistentContentTypeRenderFunctionsInVariableTag", testArrayOfInconsistentContentTypeRenderFunctionsInVariableTag),
            ("testArrayOfInconsistentContentTypeRenderFunctionsInSectionTag", testArrayOfInconsistentContentTypeRenderFunctionsInSectionTag),
            ("testDynamicPartial", testDynamicPartial),
            ("testDynamicPartialIsNotHTMLEscaped", testDynamicPartialIsNotHTMLEscaped),
            ("testDynamicPartialOverride", testDynamicPartialOverride),
            ("testArrayOfRenderFunctionsInSectionTagDoesNotNeedExplicitInvocation", testArrayOfRenderFunctionsInSectionTagDoesNotNeedExplicitInvocation),
	    ("testRenderFunctionCanThrowNSErrorFromVariableTag", testRenderFunctionCanThrowNSErrorFromVariableTag),
	    ("testRenderFunctionCanThrowNSErrorFromSectionTag", testRenderFunctionCanThrowNSErrorFromSectionTag)
	    ]
    }

    enum CustomError : Error {
        case Error
    }

    func testRenderFunctionInVariableTag() {
        let render = { (info: RenderingInfo) -> Rendering in
            return Rendering("---")
        }
        let rendering = try! Template(string: "{{.}}").render(with: Box(render))
        XCTAssertEqual(rendering, "---")
    }

    func testRenderFunctionInSectionTag() {
        let render = { (info: RenderingInfo) -> Rendering in
            return Rendering("---")
        }
        let rendering = try! Template(string: "{{#.}}{{/.}}").render(with: Box(render))
        XCTAssertEqual(rendering, "---")
    }

    func testRenderFunctionInInvertedSectionTag() {
        let render = { (info: RenderingInfo) -> Rendering in
            return Rendering("---")
        }
        let rendering = try! Template(string: "{{^.}}{{/.}}").render(with: Box(render))
        XCTAssertEqual(rendering, "")
    }

    func testRenderFunctionHTMLRenderingOfEscapedVariableTag() {
        let render = { (info: RenderingInfo) -> Rendering in
            return Rendering("&", .HTML)
        }
        let rendering = try! Template(string: "{{.}}").render(with: Box(render))
        XCTAssertEqual(rendering, "&")
    }

    func testRenderFunctionHTMLRenderingOfUnescapedVariableTag() {
        let render = { (info: RenderingInfo) -> Rendering in
            return Rendering("&", .HTML)
        }
        let rendering = try! Template(string: "{{{.}}}").render(with: Box(render))
        XCTAssertEqual(rendering, "&")
    }

    func testRenderFunctionTextRenderingOfEscapedVariableTag() {
        let render = { (info: RenderingInfo) -> Rendering in
            return Rendering("&")
        }
        let rendering = try! Template(string: "{{.}}").render(with: Box(render))
        XCTAssertEqual(rendering, "&amp;")
    }

    func testRenderFunctionTextRenderingOfUnescapedVariableTag() {
        let render = { (info: RenderingInfo) -> Rendering in
            return Rendering("&")
        }
        let rendering = try! Template(string: "{{{.}}}").render(with: Box(render))
        XCTAssertEqual(rendering, "&")
    }

    func testRenderFunctionHTMLRenderingOfSectionTag() {
        let render = { (info: RenderingInfo) -> Rendering in
            return Rendering("&", .HTML)
        }
        let rendering = try! Template(string: "{{#.}}{{/.}}").render(with: Box(render))
        XCTAssertEqual(rendering, "&")
    }

    func testRenderFunctionTextRenderingOfSectionTag() {
        let render = { (info: RenderingInfo) -> Rendering in
            return Rendering("&")
        }
        let rendering = try! Template(string: "{{#.}}{{/.}}").render(with: Box(render))
        XCTAssertEqual(rendering, "&amp;")
    }

    func testRenderFunctionCanThrowNSErrorFromVariableTag() {
        let errorDomain = "ClusterTests"
        let render = { (info: RenderingInfo) -> Rendering in
            throw NSError(domain: errorDomain, code: 0, userInfo: nil)
        }
        do {
            let _ = try Template(string: "{{.}}").render(with: Box(render))
            XCTAssert(false)
        } catch let error as NSError {
            XCTAssertEqual(error.domain, errorDomain)
        } catch {
	    XCTFail("Expected NSError")
	}
    }

    func testRenderFunctionCanThrowCustomErrorFromVariableTag() {
        let render = { (info: RenderingInfo) -> Rendering in
            throw CustomError.Error
        }
        do {
            let _ = try Template(string: "\n\n{{.}}").render(with: Box(render))
            XCTAssert(false)
        } catch CustomError.Error {
            XCTAssert(true)
        } catch {
            XCTAssert(false)
        }
    }

    func testRenderFunctionCanThrowNSErrorFromSectionTag() {
        let errorDomain = "ClusterTests"
        let render = { (info: RenderingInfo) -> Rendering in
            throw NSError(domain: errorDomain, code: 0, userInfo: nil)
        }
        do {
            let _ = try Template(string: "{{#.}}{{/.}}").render(with: Box(render))
            XCTAssert(false)
        } catch let error as NSError {
            XCTAssertEqual(error.domain, errorDomain)
        } catch {
            XCTFail("Expected NSError")
	}
    }

    func testRenderFunctionCanThrowCustomErrorFromSectionTag() {
        let render = { (info: RenderingInfo) -> Rendering in
            throw CustomError.Error
        }
        do {
            let _ = try Template(string: "\n\n{{#.}}\n\n{{/.}}").render(with: Box(render))
            XCTAssert(false)
        } catch CustomError.Error {
            XCTAssert(true)
        } catch {
            XCTAssert(false)
        }
    }

    func testRenderFunctionCanAccessVariableTagType() {
        var variableTagDetections = 0
        let render = { (info: RenderingInfo) -> Rendering in
            switch info.tag.type {
            case .Variable:
                variableTagDetections += 1
            default:
                break
            }
            return Rendering("")
        }
        let _ = try! Template(string: "{{.}}").render(with: Box(render))
        XCTAssertEqual(variableTagDetections, 1)
    }

    func testRenderFunctionCanAccessSectionTagType() {
        var sectionTagDetections = 0
        let render = { (info: RenderingInfo) -> Rendering in
            switch info.tag.type {
            case .Section:
                sectionTagDetections += 1
            default:
                break
            }
            return Rendering("")
        }
        let _ = try! Template(string: "{{#.}}{{/.}}").render(with: Box(render))
        XCTAssertEqual(sectionTagDetections, 1)
    }

    func testRenderFunctionCanAccessInnerTemplateStringFromSectionTag() {
        var innerTemplateString: String? = nil
        let render = { (info: RenderingInfo) -> Rendering in
            innerTemplateString = info.tag.innerTemplateString
            return Rendering("")
        }
        let _ = try! Template(string: "{{#.}}{{subject}}{{/.}}").render(with: Box(render))
        XCTAssertEqual(innerTemplateString!, "{{subject}}")
    }

    func testRenderFunctionCanAccessInnerTemplateStringFromVariableTag() {
        var innerTemplateString: String? = nil
        let render = { (info: RenderingInfo) -> Rendering in
            innerTemplateString = info.tag.innerTemplateString
            return Rendering("")
        }
        let _ = try! Template(string: "{{.}}").render(with: Box(render))
        XCTAssertEqual(innerTemplateString!, "")
    }

    func testRenderFunctionCanAccessRenderedContentFromSectionTag() {
        var tagRendering: Rendering? = nil
        let render = { (info: RenderingInfo) -> Rendering in
            tagRendering = try info.tag.render(with: info.context)
            return tagRendering!
        }

        let box = Box(["render": Box(render), "subject": Box("-")])
        let _ = try! Template(string: "{{#render}}{{subject}}={{subject}}{{/render}}").render(with: box)
        XCTAssertEqual(tagRendering!.string, "-=-")
        XCTAssertEqual(tagRendering!.contentType, ContentType.HTML)
    }

    func testRenderFunctionCanAccessRenderedContentFromEscapedVariableTag() {
        var tagRendering: Rendering? = nil
        let render = { (info: RenderingInfo) -> Rendering in
            tagRendering = try info.tag.render(with: info.context)
            return tagRendering!
        }

        let _ = try! Template(string: "{{.}}").render(with: Box(render))
        XCTAssertEqual(tagRendering!.string, "")
        XCTAssertEqual(tagRendering!.contentType, ContentType.HTML)
    }

    func testRenderFunctionCanAccessRenderedContentFromUnescapedVariableTag() {
        var tagRendering: Rendering? = nil
        let render = { (info: RenderingInfo) -> Rendering in
            tagRendering = try info.tag.render(with: info.context)
            return tagRendering!
        }

        let _ = try! Template(string: "{{{.}}}").render(with: Box(render))

        XCTAssertEqual(tagRendering!.string, "")
        XCTAssertEqual(tagRendering!.contentType, ContentType.HTML)
    }

    func testRenderFunctionCanRenderCurrentContextInAnotherTemplateFromVariableTag() {
        let altTemplate = try! Template(string:"{{subject}}")
        let render = { (info: RenderingInfo) -> Rendering in
            return try altTemplate.render(with: info.context)
        }
        let box = Box(["render": Box(render), "subject": Box("-")])
        let rendering = try! Template(string: "{{render}}").render(with: box)
        XCTAssertEqual(rendering, "-")
    }

    func testRenderFunctionCanRenderCurrentContextInAnotherTemplateFromSectionTag() {
        let altTemplate = try! Template(string:"{{subject}}")
        let render = { (info: RenderingInfo) -> Rendering in
            return try altTemplate.render(with: info.context)
        }
        let box = Box(["render": Box(render), "subject": Box("-")])
        let rendering = try! Template(string: "{{#render}}{{/render}}").render(with: box)
        XCTAssertEqual(rendering, "-")
    }

    func testRenderFunctionDoesNotAutomaticallyEntersVariableContextStack() {
        let keyedSubscript = { (key: String) -> MustacheBox in
            return Box("value")
        }
        let render = { (info: RenderingInfo) -> Rendering in
            return try Template(string:"key:{{key}}").render(with: info.context)
        }
        let box = Box(["render": MustacheBox(keyedSubscript: keyedSubscript, render: render)])
        let rendering = try! Template(string: "{{render}}").render(with: box)
        XCTAssertEqual(rendering, "key:")
    }

    func testRenderFunctionDoesNotAutomaticallyEntersSectionContextStack() {
        let keyedSubscript = { (key: String) -> MustacheBox in
            return Box("value")
        }
        let render = { (info: RenderingInfo) -> Rendering in
            return try info.tag.render(with: info.context)
        }
        let box = Box(["render": MustacheBox(keyedSubscript: keyedSubscript, render: render)])
        let rendering = try! Template(string: "{{#render}}key:{{key}}{{/render}}").render(with: box)
        XCTAssertEqual(rendering, "key:")
    }

    func testRenderFunctionCanExtendValueContextStackInVariableTag() {
        let render = { (info: RenderingInfo) -> Rendering in
            let context = info.context.extendedContext(by: Box(["subject2": Box("+++")]))
            let template = try! Template(string: "{{subject}}{{subject2}}")
            return try template.render(with: context)
        }
        let box = Box(["render": Box(render), "subject": Box("---")])
        let rendering = try! Template(string: "{{render}}").render(with: box)
        XCTAssertEqual(rendering, "---+++")
    }

    func testRenderFunctionCanExtendValueContextStackInSectionTag() {
        let render = { (info: RenderingInfo) -> Rendering in
            return try info.tag.render(with: info.context.extendedContext(by: Box(["subject2": Box("+++")])))
        }
        let box = Box(["render": Box(render), "subject": Box("---")])
        let rendering = try! Template(string: "{{#render}}{{subject}}{{subject2}}{{/render}}").render(with: box)
        XCTAssertEqual(rendering, "---+++")
    }

    func testRenderFunctionCanExtendWillRenderStackInVariableTag() {
        var tagWillRenderCount = 0
        let render = { (info: RenderingInfo) -> Rendering in
            let context = info.context.extendedContext(by: Box({ (tag: Tag, box: MustacheBox) -> MustacheBox in
                tagWillRenderCount += 1
                return box
            }))
            let template = try! Template(string: "{{subject}}{{subject}}")
            return try template.render(with: context)
        }
        let box = Box(["render": Box(render), "subject": Box("-")])
        let rendering = try! Template(string: "{{subject}}{{render}}{{subject}}{{subject}}{{subject}}{{subject}}").render(with: box)
        XCTAssertEqual(rendering, "-------")
        XCTAssertEqual(tagWillRenderCount, 2)
    }

    func testRenderFunctionCanExtendWillRenderStackInSectionTag() {
        var tagWillRenderCount = 0
        let render = { (info: RenderingInfo) -> Rendering in
            return try info.tag.render(with: info.context.extendedContext(by: Box({ (tag: Tag, box: MustacheBox) -> MustacheBox in
                tagWillRenderCount += 1
                return box
            })))
        }
        let box = Box(["render": Box(render), "subject": Box("-")])
        let rendering = try! Template(string: "{{subject}}{{#render}}{{subject}}{{subject}}{{/render}}{{subject}}{{subject}}{{subject}}{{subject}}").render(with: box)
        XCTAssertEqual(rendering, "-------")
        XCTAssertEqual(tagWillRenderCount, 2)
    }

    func testRenderFunctionTriggersWillRenderFunctions() {
        let willRender = { (tag: Tag, box: MustacheBox) -> MustacheBox in
            switch tag.type {
            case .Section:
                return box
            default:
                return Box("delegate")
            }
        }

        let render = { (info: RenderingInfo) -> Rendering in
            return try info.tag.render(with: info.context)
        }

        let template = try! Template(string: "{{#render}}{{subject}}{{/render}}")
        template.baseContext = template.baseContext.extendedContext(by: Box(willRender))
        let box = Box(["render": Box(render), "subject": Box("---")])
        let rendering = try! template.render(with: box)
        XCTAssertEqual(rendering, "delegate")
    }

    func testRenderFunctionTriggersWillRenderFunctionsInAnotherTemplateFromVariableTag() {
        let willRender = { (tag: Tag, box: MustacheBox) -> MustacheBox in
            switch tag.type {
            case .Section:
                return box
            default:
                return Box("delegate")
            }
        }

        let render = { (info: RenderingInfo) -> Rendering in
            let template = try Template(string: "{{subject}}")
            return try template.render(with: info.context)
        }

        let template = try! Template(string: "{{render}}")
        template.baseContext = template.baseContext.extendedContext(by: Box(willRender))
        let box = Box(["render": Box(render), "subject": Box("---")])
        let rendering = try! template.render(with: box)
        XCTAssertEqual(rendering, "delegate")
    }

    func testRenderFunctionTriggersWillRenderFunctionsInAnotherTemplateFromSectionTag() {
        let willRender = { (tag: Tag, box: MustacheBox) -> MustacheBox in
            switch tag.type {
            case .Section:
                return box
            default:
                return Box("delegate")
            }
        }

        let render = { (info: RenderingInfo) -> Rendering in
            let template = try Template(string: "{{subject}}")
            return try template.render(with: info.context)
        }

        let template = try! Template(string: "{{#render}}{{/render}}")
        template.baseContext = template.baseContext.extendedContext(by: Box(willRender))
        let box = Box(["render": Box(render), "subject": Box("---")])
        let rendering = try! template.render(with: box)
        XCTAssertEqual(rendering, "delegate")
    }

    func testArrayOfRenderFunctionsInSectionTag() {
        let render1 = { (info: RenderingInfo) -> Rendering in
            return Rendering("1")
        }
        let render2 = { (info: RenderingInfo) -> Rendering in
            return Rendering("2")
        }
        let box = Box(["items": Box([Box(render1), Box(render2)])])
        let rendering = try! Template(string: "{{#items}}{{/items}}").render(with: box)
        XCTAssertEqual(rendering, "12")
    }

    func testArrayOfRenderFunctionsInEscapedVariableTag() {
        let render1 = { (info: RenderingInfo) -> Rendering in
            return Rendering("1")
        }
        let render2 = { (info: RenderingInfo) -> Rendering in
            return Rendering("2")
        }
        let box = Box(["items": Box([Box(render1), Box(render2)])])
        let rendering = try! Template(string: "{{items}}").render(with: box)
        XCTAssertEqual(rendering, "12")
    }

    func testArrayOfHTMLRenderFunctionsInEscapedVariableTag() {
        let render1 = { (info: RenderingInfo) -> Rendering in
            return Rendering("<1>", .HTML)
        }
        let render2 = { (info: RenderingInfo) -> Rendering in
            return Rendering("<2>", .HTML)
        }
        let box = Box(["items": Box([Box(render1), Box(render2)])])
        let rendering = try! Template(string: "{{items}}").render(with: box)
        XCTAssertEqual(rendering, "<1><2>")
    }

    func testArrayOfHTMLRenderFunctionsInUnescapedVariableTag() {
        let render1 = { (info: RenderingInfo) -> Rendering in
            return Rendering("<1>", .HTML)
        }
        let render2 = { (info: RenderingInfo) -> Rendering in
            return Rendering("<2>", .HTML)
        }
        let box = Box(["items": Box([Box(render1), Box(render2)])])
        let rendering = try! Template(string: "{{{items}}}").render(with: box)
        XCTAssertEqual(rendering, "<1><2>")
    }

    func testArrayOfTextRenderFunctionsInEscapedVariableTag() {
        let render1 = { (info: RenderingInfo) -> Rendering in
            return Rendering("<1>")
        }
        let render2 = { (info: RenderingInfo) -> Rendering in
            return Rendering("<2>")
        }
        let box = Box(["items": Box([Box(render1), Box(render2)])])
        let rendering = try! Template(string: "{{items}}").render(with: box)
        XCTAssertEqual(rendering, "&lt;1&gt;&lt;2&gt;")
    }

    func testArrayOfTextRenderFunctionsInUnescapedVariableTag() {
        let render1 = { (info: RenderingInfo) -> Rendering in
            return Rendering("<1>")
        }
        let render2 = { (info: RenderingInfo) -> Rendering in
            return Rendering("<2>")
        }
        let box = Box(["items": Box([Box(render1), Box(render2)])])
        let rendering = try! Template(string: "{{{items}}}").render(with: box)
        XCTAssertEqual(rendering, "<1><2>")
    }

    func testArrayOfInconsistentContentTypeRenderFunctionsInVariableTag() {
        let render1 = { (info: RenderingInfo) -> Rendering in
            return Rendering("<1>")
        }
        let render2 = { (info: RenderingInfo) -> Rendering in
            return Rendering("<2>", .HTML)
        }
        let box = Box(["items": Box([Box(render1), Box(render2)])])
        do {
            let _ = try Template(string: "{{items}}").render(with: box)
            XCTFail("Expected MustacheError")
        } catch let error as MustacheError {
            XCTAssertEqual(error.kind, MustacheError.Kind.RenderError)
        } catch {
            XCTFail("Expected MustacheError")
        }
    }

    func testArrayOfInconsistentContentTypeRenderFunctionsInSectionTag() {
        let render1 = { (info: RenderingInfo) -> Rendering in
            return Rendering("<1>")
        }
        let render2 = { (info: RenderingInfo) -> Rendering in
            return Rendering("<2>", .HTML)
        }
        let box = Box(["items": Box([Box(render1), Box(render2)])])
        do {
            let _ = try Template(string: "{{#items}}{{/items}}").render(with: box)
            XCTFail("Expected MustacheError")
        } catch let error as MustacheError {
            XCTAssertEqual(error.kind, MustacheError.Kind.RenderError)
        } catch {
            XCTFail("Expected MustacheError")
        }
    }

    func testDynamicPartial() {
        let repository = TemplateRepository(templates: ["partial": "{{subject}}"])
        let template = try! repository.template(named: "partial")
        let box = Box(["partial": Box(template), "subject": Box("---")])
        let rendering = try! Template(string: "{{partial}}").render(with: box)
        XCTAssertEqual(rendering, "---")
    }

    func testDynamicPartialIsNotHTMLEscaped() {
        let repository = TemplateRepository(templates: ["partial": "<{{subject}}>"])
        let template = try! repository.template(named: "partial")
        let box = Box(["partial": Box(template), "subject": Box("---")])
        let rendering = try! Template(string: "{{partial}}").render(with: box)
        XCTAssertEqual(rendering, "<--->")
    }

    func testDynamicPartialOverride() {
        let repository = TemplateRepository(templates: [
            "layout": "<{{$a}}Default{{subject}}{{/a}},{{$b}}Ignored{{/b}}>",
            "partial": "[{{#layout}}---{{$b}}Overriden{{subject}}{{/b}}---{{/layout}}]"])
        let template = try! repository.template(named: "partial")
        let data = [
            "layout": Box(try! repository.template(named: "layout")),
            "subject": Box("---")]
        let rendering = try! template.render(with: Box(data))
        XCTAssertEqual(rendering, "[<Default---,Overriden--->]")
    }

    // Those tests are commented out.
    //
    // They tests a feature present in Objective-C GRMustache, that is that
    // Template(string:error:) would load partials from the "current template
    // repository", a hidden global, and process templates with the "current
    // content type", another hidden global.
    //
    // The goal is to help RenderFunctions use the Template(string:error:)
    // initializers without thinking much about the context.
    //
    // 1. They could process tag.innerTemplateString that would contain
    //    {{>partial}} tags: partials would be loaded from the correct template
    //    repository.
    // 2. They would render text or HTML depending on the rendered template.
    //
    // Actually this feature has a bug in Objective-C GRMustache: it does not
    // work in a hierarchy of directories and template files, because the
    // "current template repository" is not enough information: we also need to
    // know the ID of the "current template" to load the correct partial.
    //
    // Anyway. For the sake of simplicity, we drop this feature in
    // GRMustache.swift.
    //
    // Let's wait for a user request :-)
//    func testRenderFunctionCanAccessSiblingPartialTemplatesOfCurrentlyRenderedTemplate() {
//        let templates = [
//            "template": "{{render}}",
//            "partial": "{{subject}}",
//        ]
//        let repository = TemplateRepository(templates: templates)
//        let render = { (info: RenderingInfo) -> Rendering in
//            let altTemplate = Template(string: "{{>partial}}")!
//            return altTemplate.render(with: info.context, error: error)
//        }
//        let box = Box(["render": Box(render), "subject": Box("-")])
//        let template = repository.template(named: "template")!
//        let rendering = template.render(with: box)!
//        XCTAssertEqual(rendering, "-")
//    }
//
//    func testRenderFunctionCanAccessSiblingPartialTemplatesOfTemplateAsRenderFunction() {
//        let repository1 = TemplateRepository(templates: [
//            "template1": "{{ render }}|{{ template2 }}",
//            "partial": "partial1"])
//        let repository2 = TemplateRepository(templates: [
//            "template2": "{{ render }}",
//            "partial": "partial2"])
//        let box = Box([
//            "template2": Box(repository2.template(named: "template2")!),
//            "render": Box({ (info: RenderingInfo) -> Rendering in
//                let altTemplate = Template(string: "{{>partial}}")!
//                return altTemplate.render(with: info.context, error: error)
//            })])
//        let template = repository1.template(named: "template1")!
//        let rendering = template.render(with: box)!
//        XCTAssertEqual(rendering, "partial1|partial2")
//    }
//
//    func testRenderFunctionInheritHTMLContentTypeOfCurrentlyRenderedTemplate() {
//        let box = Box([
//            "object": Box("&"),
//            "render": Box({ (info: RenderingInfo) -> Rendering in
//                let altTemplate = Template(string: "{{ object }}")!
//                return altTemplate.render(with: info.context, error: error)
//            })])
//
//        let template = Template(string: "{{%CONTENT_TYPE:HTML}}{{render}}")!
//        let rendering = template.render(with: box)!
//        XCTAssertEqual(rendering, "&amp;")
//    }
//
//    func testRenderFunctionInheritTextContentTypeOfCurrentlyRenderedTemplate() {
//        let box = Box([
//            "object": Box("&"),
//            "render": Box({ (info: RenderingInfo) -> Rendering in
//                let altTemplate = Template(string: "{{ object }}")!
//                return altTemplate.render(with: info.context, error: error)
//            })])
//
//        let template = Template(string: "{{%CONTENT_TYPE:TEXT}}{{render}}")!
//        let rendering = template.render(with: box)!
//        XCTAssertEqual(rendering, "&")
//    }
//
//    func testRenderFunctionInheritContentTypeFromPartial() {
//        let repository = TemplateRepository(templates: [
//            "templateHTML": "{{ render }}|{{> templateText }}",
//            "templateText": "{{% CONTENT_TYPE:TEXT }}{{ render }}"])
//        let box = Box([
//            "value": Box("&"),
//            "render": Box({ (info: RenderingInfo) -> Rendering in
//                let altTemplate = Template(string: "{{ value }}")!
//                return altTemplate.render(with: info.context, error: error)
//            })])
//        let template = repository.template(named: "templateHTML")!
//        let rendering = template.render(with: box)!
//        XCTAssertEqual(rendering, "&amp;|&amp;")
//    }
//
//    func testRenderFunctionInheritContentTypeFromTemplateAsRenderFunction() {
//        let repository1 = TemplateRepository(templates: [
//            "templateHTML": "{{ render }}|{{ templateText }}"])
//        let repository2 = TemplateRepository(templates: [
//            "templateText": "{{ render }}"])
//        repository2.configuration.contentType = .Text
//
//        let render = { (info: RenderingInfo) -> Rendering in
//            let altTemplate = Template(string: "{{{ value }}}")!
//            return altTemplate.render(with: info.context, error: error)
//        }
//        let box = Box([
//            "value": Box("&"),
//            "templateText": Box(repository2.template(named: "templateText")!),
//            "render": Box(render)])
//        let template = repository1.template(named: "templateHTML")!
//        let rendering = template.render(with: box)!
//        XCTAssertEqual(rendering, "&|&amp;")
//    }

    func testArrayOfRenderFunctionsInSectionTagDoesNotNeedExplicitInvocation() {
        let render1 = { (info: RenderingInfo) -> Rendering in
            let rendering = try! info.tag.render(with: info.context)
            return Rendering("[1:\(rendering.string)]", rendering.contentType)
        }
        let render2 = { (info: RenderingInfo) -> Rendering in
            let rendering = try! info.tag.render(with: info.context)
            return Rendering("[2:\(rendering.string)]", rendering.contentType)
        }
        let renders = [Box(render1), Box(render2), Box(true), Box(false)]
        let template = try! Template(string: "{{#items}}---{{/items}},{{#items}}{{#.}}---{{/.}}{{/items}}")
        let rendering = try! template.render(with: Box(["items":Box(renders)]))
        XCTAssertEqual(rendering, "[1:---][2:---]------,[1:---][2:---]---")
    }
}
