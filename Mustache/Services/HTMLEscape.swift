//
//  HTMLEscape.swift
//
//  Created by Gwendal Roué on 01/11/2014.
//  Copyright (c) 2014 Gwendal Roué. All rights reserved.
//

class HTMLEscape: MustacheBoxable {
    
    private func render(info: RenderingInfo, error: NSErrorPointer) -> Rendering? {
        switch info.tag.type {
        case .Variable:
            return Rendering("\(self)")
        case .Section:
            return info.tag.render(info.context.extendedContext(Box(self)), error: error)
        }
    }
    
    private func filter(box: MustacheBox, error: NSErrorPointer) -> MustacheBox? {
        if let string = box.stringValue {
            return Box(escapeHTML(string))
        } else {
            return Box()
        }
    }
    
    private func willRender(tag: Tag, box: MustacheBox) -> MustacheBox {
        switch tag.type {
        case .Variable:
            // {{ value }}
            //
            // We can not escape `object`, because it is not a string.
            // We want to escape its rendering.
            // So return a rendering object that will eventually render `object`,
            // and escape its rendering.
            return Box({ (info: RenderingInfo, error: NSErrorPointer) -> Rendering? in
                if let rendering = box.render(info: info, error: error) {
                    return Rendering(escapeHTML(rendering.string), rendering.contentType)
                } else {
                    return nil
                }
            })
        case .Section:
            return box
        }
    }
    
    // MARK: - MustacheBoxable
    
    var mustacheBox: MustacheBox {
        return Box(
            value: self,
            render: render,
            filter: Filter(filter),
            willRender: willRender)
    }
}