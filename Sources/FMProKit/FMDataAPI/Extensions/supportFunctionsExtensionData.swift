//
//  File.swift
//
//
//  Created by Coderly Studio (Francesco De Marco, Gianluca Annina, Giuseppe Carannante) on 24/12/22.
//

import Foundation
public extension FMDataAPI {
    /// The function is used to search records that match some given values
    /// - Parameters:
    ///   - table: The name of the table where is needed to fetch the rows
    ///   - data: Data that matches one or more records on the database
    /// - Returns: All the recordIDs that match the values
    /// - Throws: a CommonErrors.tableNameMissing error when the table parameter is empty
    /// - Throws: an HTTPError.errorCode_500_internalServerError error when using the wrong table name or when inserting wrong data inside the table
    func findRecordIds<T: Codable>(table: String, data: T) async throws -> [FieldData<T>] {
        if table.isEmpty {
            throw FMProErrors.tableNameMissing
        }
        
        let url = "\(baseUri)/layouts/\(table)/_find"
        let query = Query(query: [data])
        
        do {
            let fetchedData = try await executeRequest(urlTmp: url, method: .post, data: query)
            let fetchedIds = try JSONDecoder().decode(DataModel<T>.self, from: fetchedData)
            
            return fetchedIds.response.data
        } catch {
            try await fetchToken()
            return try await findRecordIds(table: table, data: data)
        }
    }
}
