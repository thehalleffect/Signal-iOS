//
//  Copyright (c) 2019 Open Whisper Systems. All rights reserved.
//

import Foundation
import GRDBCipher
import SignalCoreKit

// NOTE: This file is generated by /Scripts/sds_codegen/sds_generate.py.
// Do not manually edit it, instead run `sds_codegen.sh`.

// MARK: - Record

public struct UserProfileRecord: Codable, FetchableRecord, PersistableRecord, TableRecord {
    public static let databaseTableName: String = OWSUserProfileSerializer.table.tableName

    public let id: UInt64

    // This defines all of the columns used in the table
    // where this model (and any subclasses) are persisted.
    public let recordType: SDSRecordType
    public let uniqueId: String

    // Base class properties
    public let avatarFileName: String?
    public let avatarUrlPath: String?
    public let profileKey: Data?
    public let profileName: String?
    public let recipientId: String

    public enum CodingKeys: String, CodingKey, ColumnExpression, CaseIterable {
        case id
        case recordType
        case uniqueId
        case avatarFileName
        case avatarUrlPath
        case profileKey
        case profileName
        case recipientId
    }

    public static func columnName(_ column: UserProfileRecord.CodingKeys) -> String {
        return column.rawValue
    }

}

// MARK: - StringInterpolation

public extension String.StringInterpolation {
    mutating func appendInterpolation(columnForUserProfile column: UserProfileRecord.CodingKeys) {
        appendLiteral(UserProfileRecord.columnName(column))
    }
}

// MARK: - Deserialization

// TODO: Remove the other Deserialization extension.
// TODO: SDSDeserializer.
// TODO: Rework metadata to not include, for example, columns, column indices.
extension OWSUserProfile {
    // This method defines how to deserialize a model, given a
    // database row.  The recordType column is used to determine
    // the corresponding model class.
    class func fromRecord(_ record: UserProfileRecord) throws -> OWSUserProfile {

        switch record.recordType {
        case .userProfile:

            let uniqueId: String = record.uniqueId
            let sortId: UInt64 = record.id
            let avatarFileName: String? = SDSDeserialization.optionalString(record.avatarFileName, name: "avatarFileName")
            let avatarUrlPath: String? = SDSDeserialization.optionalString(record.avatarUrlPath, name: "avatarUrlPath")
            let profileKeySerialized: Data? = record.profileKey
            let profileKey: OWSAES256Key? = try SDSDeserialization.optionalUnarchive(profileKeySerialized, name: "profileKey")
            let profileName: String? = SDSDeserialization.optionalString(record.profileName, name: "profileName")
            let recipientId: String = record.recipientId

            return OWSUserProfile(uniqueId: uniqueId,
                                  avatarFileName: avatarFileName,
                                  avatarUrlPath: avatarUrlPath,
                                  profileKey: profileKey,
                                  profileName: profileName,
                                  recipientId: recipientId)

        default:
            owsFailDebug("Unexpected record type: \(record.recordType)")
            throw SDSError.invalidValue
        }
    }
}

// MARK: - SDSSerializable

extension OWSUserProfile: SDSSerializable {
    public var serializer: SDSSerializer {
        // Any subclass can be cast to it's superclass,
        // so the order of this switch statement matters.
        // We need to do a "depth first" search by type.
        switch self {
        default:
            return OWSUserProfileSerializer(model: self)
        }
    }
}

// MARK: - Table Metadata

extension OWSUserProfileSerializer {

    // This defines all of the columns used in the table
    // where this model (and any subclasses) are persisted.
    static let recordTypeColumn = SDSColumnMetadata(columnName: "recordType", columnType: .int, columnIndex: 0)
    static let idColumn = SDSColumnMetadata(columnName: "id", columnType: .primaryKey, columnIndex: 1)
    static let uniqueIdColumn = SDSColumnMetadata(columnName: "uniqueId", columnType: .unicodeString, columnIndex: 2)
    // Base class properties
    static let avatarFileNameColumn = SDSColumnMetadata(columnName: "avatarFileName", columnType: .unicodeString, isOptional: true, columnIndex: 3)
    static let avatarUrlPathColumn = SDSColumnMetadata(columnName: "avatarUrlPath", columnType: .unicodeString, isOptional: true, columnIndex: 4)
    static let profileKeyColumn = SDSColumnMetadata(columnName: "profileKey", columnType: .blob, isOptional: true, columnIndex: 5)
    static let profileNameColumn = SDSColumnMetadata(columnName: "profileName", columnType: .unicodeString, isOptional: true, columnIndex: 6)
    static let recipientIdColumn = SDSColumnMetadata(columnName: "recipientId", columnType: .unicodeString, columnIndex: 7)

    // TODO: We should decide on a naming convention for
    //       tables that store models.
    public static let table = SDSTableMetadata(tableName: "model_OWSUserProfile", columns: [
        recordTypeColumn,
        idColumn,
        uniqueIdColumn,
        avatarFileNameColumn,
        avatarUrlPathColumn,
        profileKeyColumn,
        profileNameColumn,
        recipientIdColumn
        ])

}

// MARK: - Deserialization

extension OWSUserProfileSerializer {
    // This method defines how to deserialize a model, given a
    // database row.  The recordType column is used to determine
    // the corresponding model class.
    class func sdsDeserialize(statement: SelectStatement) throws -> OWSUserProfile {

        if OWSIsDebugBuild() {
            guard statement.columnNames == table.selectColumnNames else {
                owsFailDebug("Unexpected columns: \(statement.columnNames) != \(table.selectColumnNames)")
                throw SDSError.invalidResult
            }
        }

        // SDSDeserializer is used to convert column values into Swift values.
        let deserializer = SDSDeserializer(sqliteStatement: statement.sqliteStatement)
        let recordTypeValue = try deserializer.int(at: 0)
        guard let recordType = SDSRecordType(rawValue: UInt(recordTypeValue)) else {
            owsFailDebug("Invalid recordType: \(recordTypeValue)")
            throw SDSError.invalidResult
        }
        switch recordType {
        case .userProfile:

            let uniqueId = try deserializer.string(at: uniqueIdColumn.columnIndex)
            let avatarFileName = try deserializer.optionalString(at: avatarFileNameColumn.columnIndex)
            let avatarUrlPath = try deserializer.optionalString(at: avatarUrlPathColumn.columnIndex)
            let profileKeySerialized: Data? = try deserializer.optionalBlob(at: profileKeyColumn.columnIndex)
            let profileKey: OWSAES256Key? = try SDSDeserializer.optionalUnarchive(profileKeySerialized)
            let profileName = try deserializer.optionalString(at: profileNameColumn.columnIndex)
            let recipientId = try deserializer.string(at: recipientIdColumn.columnIndex)

            return OWSUserProfile(uniqueId: uniqueId,
                                  avatarFileName: avatarFileName,
                                  avatarUrlPath: avatarUrlPath,
                                  profileKey: profileKey,
                                  profileName: profileName,
                                  recipientId: recipientId)

        default:
            owsFail("Invalid record type \(recordType)")
        }
    }
}

// MARK: - Save/Remove/Update

@objc
extension OWSUserProfile {
    public func anySave(transaction: SDSAnyWriteTransaction) {
        switch transaction.writeTransaction {
        case .yapWrite(let ydbTransaction):
            save(with: ydbTransaction)
        case .grdbWrite(let grdbTransaction):
            SDSSerialization.save(entity: self, transaction: grdbTransaction)
        }
    }

    // This method is used by "updateWith..." methods.
    //
    // This model may be updated from many threads. We don't want to save
    // our local copy (this instance) since it may be out of date.  We also
    // want to avoid re-saving a model that has been deleted.  Therefore, we
    // use "updateWith..." methods to:
    //
    // a) Update a property of this instance.
    // b) If a copy of this model exists in the database, load an up-to-date copy,
    //    and update and save that copy.
    // b) If a copy of this model _DOES NOT_ exist in the database, do _NOT_ save
    //    this local instance.
    //
    // After "updateWith...":
    //
    // a) Any copy of this model in the database will have been updated.
    // b) The local property on this instance will always have been updated.
    // c) Other properties on this instance may be out of date.
    //
    // All mutable properties of this class have been made read-only to
    // prevent accidentally modifying them directly.
    //
    // This isn't a perfect arrangement, but in practice this will prevent
    // data loss and will resolve all known issues.
    public func anyUpdateWith(transaction: SDSAnyWriteTransaction, block: (OWSUserProfile) -> Void) {
        guard let uniqueId = uniqueId else {
            owsFailDebug("Missing uniqueId.")
            return
        }

        guard let dbCopy = type(of: self).anyFetch(uniqueId: uniqueId,
                                                   transaction: transaction) else {
            return
        }

        block(self)
        block(dbCopy)

        dbCopy.anySave(transaction: transaction)
    }

    public func anyRemove(transaction: SDSAnyWriteTransaction) {
        switch transaction.writeTransaction {
        case .yapWrite(let ydbTransaction):
            remove(with: ydbTransaction)
        case .grdbWrite(let grdbTransaction):
            SDSSerialization.delete(entity: self, transaction: grdbTransaction)
        }
    }
}

// MARK: - OWSUserProfileCursor

@objc
public class OWSUserProfileCursor: NSObject {
    private let cursor: SDSCursor<OWSUserProfile>

    init(cursor: SDSCursor<OWSUserProfile>) {
        self.cursor = cursor
    }

    // TODO: Revisit error handling in this class.
    public func next() throws -> OWSUserProfile? {
        return try cursor.next()
    }

    public func all() throws -> [OWSUserProfile] {
        return try cursor.all()
    }
}

// MARK: - Obj-C Fetch

// TODO: We may eventually want to define some combination of:
//
// * fetchCursor, fetchOne, fetchAll, etc. (ala GRDB)
// * Optional "where clause" parameters for filtering.
// * Async flavors with completions.
//
// TODO: I've defined flavors that take a read transaction.
//       Or we might take a "connection" if we end up having that class.
@objc
extension OWSUserProfile {
    public class func grdbFetchCursor(transaction: GRDBReadTransaction) -> OWSUserProfileCursor {
        return OWSUserProfileCursor(cursor: SDSSerialization.fetchCursor(tableMetadata: OWSUserProfileSerializer.table,
                                                                   transaction: transaction,
                                                                   deserialize: OWSUserProfileSerializer.sdsDeserialize))
    }

    // Fetches a single model by "unique id".
    public class func anyFetch(uniqueId: String,
                               transaction: SDSAnyReadTransaction) -> OWSUserProfile? {
        assert(uniqueId.count > 0)

        switch transaction.readTransaction {
        case .yapRead(let ydbTransaction):
            return OWSUserProfile.fetch(uniqueId: uniqueId, transaction: ydbTransaction)
        case .grdbRead(let grdbTransaction):
            let sql = "SELECT * FROM \(UserProfileRecord.databaseTableName) WHERE \(columnForUserProfile: .uniqueId) = ?"
            return grdbFetchOne(sql: sql, arguments: [uniqueId], transaction: grdbTransaction)
        }
    }

    // Traverses all records.
    // Records are not visited in any particular order.
    // Traversal aborts if the visitor returns false.
    public class func anyVisitAll(transaction: SDSAnyReadTransaction, visitor: @escaping (OWSUserProfile) -> Bool) {
        switch transaction.readTransaction {
        case .yapRead(let ydbTransaction):
            OWSUserProfile.enumerateCollectionObjects(with: ydbTransaction) { (object, stop) in
                guard let value = object as? OWSUserProfile else {
                    owsFailDebug("unexpected object: \(type(of: object))")
                    return
                }
                guard visitor(value) else {
                    stop.pointee = true
                    return
                }
            }
        case .grdbRead(let grdbTransaction):
            do {
                let cursor = OWSUserProfile.grdbFetchCursor(transaction: grdbTransaction)
                while let value = try cursor.next() {
                    guard visitor(value) else {
                        return
                    }
                }
            } catch let error as NSError {
                owsFailDebug("Couldn't fetch models: \(error)")
            }
        }
    }

    // Does not order the results.
    public class func anyFetchAll(transaction: SDSAnyReadTransaction) -> [OWSUserProfile] {
        var result = [OWSUserProfile]()
        anyVisitAll(transaction: transaction) { (model) in
            result.append(model)
            return true
        }
        return result
    }
}

// MARK: - Swift Fetch

extension OWSUserProfile {
    public class func grdbFetchCursor(sql: String,
                                      arguments: [DatabaseValueConvertible]?,
                                      transaction: GRDBReadTransaction) -> OWSUserProfileCursor {
        var statementArguments: StatementArguments?
        if let arguments = arguments {
            guard let statementArgs = StatementArguments(arguments) else {
                owsFail("Could not convert arguments.")
            }
            statementArguments = statementArgs
        }
        return OWSUserProfileCursor(cursor: SDSSerialization.fetchCursor(sql: sql,
                                                             arguments: statementArguments,
                                                             transaction: transaction,
                                                                   deserialize: OWSUserProfileSerializer.sdsDeserialize))
    }

    public class func grdbFetchOne(sql: String,
                                   arguments: StatementArguments,
                                   transaction: GRDBReadTransaction) -> OWSUserProfile? {
        assert(sql.count > 0)

        do {
            guard let record = try UserProfileRecord.fetchOne(transaction.database, sql: sql, arguments: arguments) else {
                return nil
            }

            return try OWSUserProfile.fromRecord(record)
        } catch {
            owsFailDebug("error: \(error)")
            return nil
        }
    }
}

// MARK: - SDSSerializer

// The SDSSerializer protocol specifies how to insert and update the
// row that corresponds to this model.
class OWSUserProfileSerializer: SDSSerializer {

    private let model: OWSUserProfile
    public required init(model: OWSUserProfile) {
        self.model = model
    }

    public func serializableColumnTableMetadata() -> SDSTableMetadata {
        return OWSUserProfileSerializer.table
    }

    public func insertColumnNames() -> [String] {
        // When we insert a new row, we include the following columns:
        //
        // * "record type"
        // * "unique id"
        // * ...all columns that we set when updating.
        return [
            OWSUserProfileSerializer.recordTypeColumn.columnName,
            uniqueIdColumnName()
            ] + updateColumnNames()

    }

    public func insertColumnValues() -> [DatabaseValueConvertible] {
        let result: [DatabaseValueConvertible] = [
            SDSRecordType.userProfile.rawValue
            ] + [uniqueIdColumnValue()] + updateColumnValues()
        if OWSIsDebugBuild() {
            if result.count != insertColumnNames().count {
                owsFailDebug("Update mismatch: \(result.count) != \(insertColumnNames().count)")
            }
        }
        return result
    }

    public func updateColumnNames() -> [String] {
        return [
            OWSUserProfileSerializer.avatarFileNameColumn,
            OWSUserProfileSerializer.avatarUrlPathColumn,
            OWSUserProfileSerializer.profileKeyColumn,
            OWSUserProfileSerializer.profileNameColumn,
            OWSUserProfileSerializer.recipientIdColumn
            ].map { $0.columnName }
    }

    public func updateColumnValues() -> [DatabaseValueConvertible] {
        let result: [DatabaseValueConvertible] = [
            self.model.avatarFileName ?? DatabaseValue.null,
            self.model.avatarUrlPath ?? DatabaseValue.null,
            SDSDeserializer.archive(self.model.profileKey) ?? DatabaseValue.null,
            self.model.profileName ?? DatabaseValue.null,
            self.model.recipientId

        ]
        if OWSIsDebugBuild() {
            if result.count != updateColumnNames().count {
                owsFailDebug("Update mismatch: \(result.count) != \(updateColumnNames().count)")
            }
        }
        return result
    }

    public func uniqueIdColumnName() -> String {
        return OWSUserProfileSerializer.uniqueIdColumn.columnName
    }

    // TODO: uniqueId is currently an optional on our models.
    //       We should probably make the return type here String?
    public func uniqueIdColumnValue() -> DatabaseValueConvertible {
        // FIXME remove force unwrap
        return model.uniqueId!
    }
}
