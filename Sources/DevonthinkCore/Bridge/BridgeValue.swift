import Foundation
import ScriptingBridge

private func unwrapOptional(_ value: Any) -> Any? {
    let mirror = Mirror(reflecting: value)
    guard mirror.displayStyle == .optional else { return value }
    guard let child = mirror.children.first else { return nil }
    return unwrapOptional(child.value)
}

func resolvedAny(_ value: Any?) -> Any? {
    guard let value else { return nil }

    if let object = value as? SBObject {
        guard let resolved = object.get() else { return nil }
        return unwrapOptional(resolved)
    }

    return unwrapOptional(value)
}

func resolvedValue<T>(_ value: Any?) -> T? {
    guard let resolved = resolvedAny(value) else { return nil }
    return resolved as? T
}

func resolvedString(_ value: Any?) -> String? {
    if let string: String = resolvedValue(value) {
        return string
    }
    if let attributed: NSAttributedString = resolvedValue(value) {
        return attributed.string
    }
    return nil
}

func resolvedStrings(_ value: Any?) -> [String] {
    if let strings: [String] = resolvedValue(value) {
        return strings
    }
    if let array = resolvedAny(value) as? NSArray {
        return array.compactMap { $0 as? String }
    }
    return []
}

func resolvedDate(_ value: Any?) -> Date? {
    resolvedValue(value)
}

func resolvedRecord(_ value: Any?) -> DEVONthinkRecord? {
    resolvedValue(value)
}

func resolvedParent(_ value: Any?) -> DEVONthinkParent? {
    resolvedValue(value)
}

func resolvedDatabase(_ value: Any?) -> DEVONthinkDatabase? {
    resolvedValue(value)
}
