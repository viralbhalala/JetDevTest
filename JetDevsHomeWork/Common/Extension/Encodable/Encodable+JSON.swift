//
//  Encodable+JSON.swift
//  JetDevsHomeWork
//
//  Created by Developer on 26/12/22.
//

import Foundation

extension Encodable {

    public func toJSON() -> [String: Any] {

        guard let data = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(
                with: data,
                options: .allowFragments
              ),
              let json = dictionary as? [String: Any] else {
                return [:]
        }

        return json
    }

    public func toJSONString(encoder: JSONEncoder = JSONEncoder()) -> String? {

        guard let data = try? encoder.encode(self), let jsonString = String(data: data, encoding: .utf8) else {
            return nil
        }

        return jsonString
    }
}
