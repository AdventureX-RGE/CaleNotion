//
//  BlockType+.swift
//
//
//  Created by 朱浩宇 on 2024/1/28.
//

import Foundation
import NotionSwift

extension BlockType {
    func toString() -> String {
        switch self {
        case .paragraph(let textAndChildrenBlockValue):
            textAndChildrenBlockValue.richText.reduce(into: "") { partialResult, rt in
                partialResult += rt.plainText ?? ""
            }
        case .heading1(let headingBlockValue):
            headingBlockValue.richText.reduce(into: "# ") { partialResult, rt in
                partialResult += rt.plainText ?? ""
            }
        case .heading2(let headingBlockValue):
            headingBlockValue.richText.reduce(into: "## ") { partialResult, rt in
                partialResult += rt.plainText ?? ""
            }
        case .heading3(let headingBlockValue):
            headingBlockValue.richText.reduce(into: "### ") { partialResult, rt in
                partialResult += rt.plainText ?? ""
            }
        case .bulletedListItem(let textAndChildrenBlockValue):
            textAndChildrenBlockValue.richText.reduce(into: "") { partialResult, rt in
                partialResult += rt.plainText ?? ""
            }
        case .numberedListItem(let textAndChildrenBlockValue):
            textAndChildrenBlockValue.richText.reduce(into: "") { partialResult, rt in
                partialResult += rt.plainText ?? ""
            }
        case .toDo(let toDoBlockValue):
            toDoBlockValue.richText.reduce(into: "[\((toDoBlockValue.checked ?? false) ? "X" : " ")]") { partialResult, rt in
                partialResult += rt.plainText ?? ""
            }
        case .toggle(let textAndChildrenBlockValue):
            textAndChildrenBlockValue.richText.reduce(into: "") { partialResult, rt in
                partialResult += rt.plainText ?? ""
            }
        case .code(let codeBlockValue):
            codeBlockValue.richText.reduce(into: "") { partialResult, rt in
                partialResult += rt.plainText ?? ""
            }
        case .childPage(let childPageBlockValue):
            "Page: \(childPageBlockValue.title)"
        case .childDatabase(let childDatabaseBlockValue):
            "Database: \(childDatabaseBlockValue.title)"
        case .embed(let embedBlockValue):
            embedBlockValue.url
        case .callout(let calloutBlockValue):
            calloutBlockValue.richText.reduce(into: "") { partialResult, rt in
                partialResult += rt.plainText ?? ""
            }
        case .quote(let quoteBlockValue):
            quoteBlockValue.richText.reduce(into: "") { partialResult, rt in
                partialResult += rt.plainText ?? ""
            }
        case .video(let fileBlockValue):
            fileBlockValue.caption.reduce(into: "video: ") { partialResult, rt in
                partialResult += rt.plainText ?? ""
            }
        case .audio(let fileBlockValue):
            fileBlockValue.caption.reduce(into: "audio: ") { partialResult, rt in
                partialResult += rt.plainText ?? ""
            }
        case .image(let fileBlockValue):
            fileBlockValue.caption.reduce(into: "image: ") { partialResult, rt in
                partialResult += rt.plainText ?? ""
            }
        case .file(let fileBlockValue):
            fileBlockValue.caption.reduce(into: "file: ") { partialResult, rt in
                partialResult += rt.plainText ?? ""
            }
        case .pdf(let fileBlockValue):
            fileBlockValue.caption.reduce(into: "pdf: ") { partialResult, rt in
                partialResult += rt.plainText ?? ""
            }
        case .bookmark(let bookmarkBlockValue):
            bookmarkBlockValue.url
        case .equation(let equationBlockValue):
            equationBlockValue.expression
        case .divider:
            "--------------"
        case .tableOfContents(_):
            ""
        case .breadcrumb:
            ""
        case .column(_):
            ""
        case .columnList(_):
            ""
        case .linkToPage(_):
            ""
        case .syncedBlock(_):
            ""
        case .template(_):
            ""
        case .table(_):
            ""
        case .tableRow(_):
            ""
        case .unsupported(_):
            ""
        }
    }
}
