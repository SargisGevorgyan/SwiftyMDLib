//
//  Array+Tools.swift
//
//  Copyright © 2022 MagicDevs. All rights reserved.
//

import Foundation

public extension Encodable {

    public func toData() -> Data? {
        let data = try? JSONEncoder().encode(self)
        return data
    }
}

public extension String {
    public static func jsonString(from object: Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .fragmentsAllowed]) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }

    public static func jsonString(from data: Data) -> String? {
        return String(data: data, encoding: String.Encoding.utf8)
    }

    public static func jsonString<T: Codable>(codable: T) -> String {
        var str = ""
        let encoder = JSONEncoder()
        let data = try? encoder.encode(codable)
        if let data = data {
            str = String(data: data, encoding: .utf8) ?? ""
        }
        return str
    }

}

public extension Data {
    public static func data(from object: Any?) -> Data? {
        guard let object = object else {
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .fragmentsAllowed]) else {
            return nil
        }
        return data
    }

    public func decode<T: Codable>() -> T? {
        do {
            let decoder = JSONDecoder()

            let result = try decoder.decode(T.self, from: self)
            return result

        } catch {
            print(error)
            return nil
        }
    }
}

public struct DataDecoder<T: Codable> {
    public static func decode(for object: Any?) -> T? {
        do {
            let decoder = JSONDecoder()

            guard let data = Data.data(from: object) else {return nil}

            let result = try decoder.decode(T.self, from: data)
            return result

        } catch {
            print(error)
            return nil
        }
    }

    public static func decode(for data: Data?) -> T? {
      do {
          let decoder = JSONDecoder()

          guard let data = data else {return nil}

          let result = try decoder.decode(T.self, from: data)
          return result

      } catch {
          print(error)
          return nil
      }
  }
}

