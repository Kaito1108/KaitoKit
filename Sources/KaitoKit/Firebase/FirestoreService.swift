import Foundation

/// FirestoreServiceを使用するには、プロジェクトにFirebase SDKを追加する必要があります。
///
/// Package.swiftに以下を追加:
/// ```swift
/// .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.0.0"),
/// ```
///
/// そして、ターゲットの依存関係に追加:
/// ```swift
/// .product(name: "FirebaseFirestore", package: "firebase-ios-sdk")
/// ```
///
/// コード内では:
/// ```swift
/// import KaitoKit
/// import FirebaseFirestore
/// ```

import FirebaseFirestore

// MARK: - Firestore Errors

public enum FirestoreSetError: Error {
    case setError
}

public enum FirestoreFetchError: Error {
    case fetchError
    case nilError
}

public enum FirestoreUpdateError: Error {
    case updateError
}

public enum FirestoreDeleteError: Error {
    case deleteError
}

// MARK: - Firestore Service

public class FirestoreService {
    public static let shared: FirestoreService = FirestoreService()

    private init() {}

    // MARK: - Basic Operations

    /// データを作成
    public func setData(collectionName: String, documentName: String, data: [String: Any]) async throws {
        let db = Firestore.firestore()

        try await withCheckedThrowingContinuation { continuation in
            db.collection(collectionName).document(documentName).setData(data) { error in
                if let error = error {
                    continuation.resume(throwing: FirestoreSetError.setError)
                } else {
                    continuation.resume(returning: ())
                }
            }
        } as Void
    }

    /// データを取得
    public func fetchData<T: Decodable>(collectionName: String, documentName: String, fieldName: String) async throws -> T {
        let db = Firestore.firestore()

        return try await withCheckedThrowingContinuation { continuation in
            db.collection(collectionName).document(documentName).getDocument { (document, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                if let document = document, document.exists {
                    if let data = document.data(),
                       let fieldValue = data[fieldName] as? T {
                        continuation.resume(returning: fieldValue)
                    } else {
                        continuation.resume(throwing: FirestoreFetchError.nilError)
                    }
                } else {
                    continuation.resume(throwing: FirestoreFetchError.fetchError)
                }
            }
        }
    }

    /// データを更新
    public func updateData(collectionName: String, documentName: String, data: [String: Any]) async throws {
        let db = Firestore.firestore()

        try await withCheckedThrowingContinuation { continuation in
            db.collection(collectionName).document(documentName).updateData(data) { error in
                if let error = error {
                    print("FirestoreService.updateData error: \(error)")
                    continuation.resume(throwing: FirestoreUpdateError.updateError)
                } else {
                    continuation.resume(returning: ())
                }
            }
        } as Void
    }

    /// ドキュメントを削除
    public func deleteDocument(collectionName: String, documentName: String) async throws {
        let db = Firestore.firestore()

        try await withCheckedThrowingContinuation { continuation in
            db.collection(collectionName).document(documentName).delete() { error in
                if let error = error {
                    print("FirestoreService.deleteDocument error: \(error)")
                    continuation.resume(throwing: FirestoreDeleteError.deleteError)
                } else {
                    continuation.resume(returning: ())
                }
            }
        } as Void
    }

    // MARK: - SubCollection Operations

    /// サブコレクションにデータを作成
    public func setSubData(collectionName: String, documentName: String, subCollectionName: String, subDocumentName: String, data: [String: Any]) async throws {
        let db = Firestore.firestore()

        try await withCheckedThrowingContinuation { continuation in
            db.collection(collectionName)
                .document(documentName)
                .collection(subCollectionName)
                .document(subDocumentName)
                .setData(data) { error in
                    if let error = error {
                        continuation.resume(throwing: FirestoreSetError.setError)
                    } else {
                        continuation.resume(returning: ())
                    }
                }
        } as Void
    }

    /// サブコレクションからデータを取得
    public func fetchSubData<T: Decodable>(collectionName: String, documentName: String, subCollectionName: String, subDocumentName: String, fieldName: String) async throws -> T {
        let db = Firestore.firestore()

        return try await withCheckedThrowingContinuation { continuation in
            db.collection(collectionName)
                .document(documentName)
                .collection(subCollectionName)
                .document(subDocumentName)
                .getDocument { (document, error) in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }

                    if let document = document, document.exists {
                        if let data = document.data(),
                           let fieldValue = data[fieldName] as? T {
                            continuation.resume(returning: fieldValue)
                        } else {
                            continuation.resume(throwing: FirestoreFetchError.nilError)
                        }
                    } else {
                        continuation.resume(throwing: FirestoreFetchError.fetchError)
                    }
                }
        }
    }

    /// サブコレクションのデータを更新
    public func updateSubData(collectionName: String, documentName: String, subCollectionName: String, subDocumentName: String, data: [String: Any]) async throws {
        let db = Firestore.firestore()

        try await withCheckedThrowingContinuation { continuation in
            db.collection(collectionName)
                .document(documentName)
                .collection(subCollectionName)
                .document(subDocumentName)
                .updateData(data) { error in
                    if let error = error {
                        print("FirestoreService.updateSubData error: \(error)")
                        continuation.resume(throwing: FirestoreUpdateError.updateError)
                    } else {
                        continuation.resume(returning: ())
                    }
                }
        } as Void
    }

    /// サブドキュメントを削除
    public func deleteSubDocument(collectionName: String, documentName: String, subCollectionName: String, subDocumentName: String) async throws {
        let db = Firestore.firestore()

        try await withCheckedThrowingContinuation { continuation in
            db.collection(collectionName)
                .document(documentName)
                .collection(subCollectionName)
                .document(subDocumentName)
                .delete() { error in
                    if let error = error {
                        print("FirestoreService.deleteSubDocument error: \(error)")
                        continuation.resume(throwing: FirestoreDeleteError.deleteError)
                    } else {
                        continuation.resume(returning: ())
                    }
                }
        } as Void
    }

    // MARK: - Utility Operations

    /// ドキュメントの存在確認
    public func checkDocumentExists(collectionName: String, documentName: String) async throws -> Bool {
        let db = Firestore.firestore()

        return try await withCheckedThrowingContinuation { continuation in
            db.collection(collectionName).document(documentName).getDocument { (document, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                if let document = document, document.exists {
                    continuation.resume(returning: true)
                } else {
                    continuation.resume(returning: false)
                }
            }
        }
    }

    /// コレクション内の値の存在確認
    public func checkValueExistsInCollection(collectionName: String, fieldToCheck: String, valueToCompare: String) async throws -> Bool {
        let db = Firestore.firestore()

        return try await withCheckedThrowingContinuation { continuation in
            db.collection(collectionName).getDocuments { (querySnapshot, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    continuation.resume(returning: false)
                    return
                }

                for document in documents {
                    if let fieldValue = document.data()[fieldToCheck] as? String {
                        if fieldValue == valueToCompare {
                            continuation.resume(returning: true)
                            return
                        }
                    }
                }

                continuation.resume(returning: false)
            }
        }
    }

    /// サブコレクション内の値の存在確認
    public func checkValueExistsInSubCollection(collectionName: String, documentName: String, subCollectionName: String, fieldToCheck: String, valueToCompare: String) async throws -> Bool {
        let db = Firestore.firestore()

        return try await withCheckedThrowingContinuation { continuation in
            db.collection(collectionName).document(documentName).collection(subCollectionName).getDocuments { (querySnapshot, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    continuation.resume(returning: false)
                    return
                }

                for document in documents {
                    if let fieldValue = document.data()[fieldToCheck] as? String {
                        if fieldValue == valueToCompare {
                            continuation.resume(returning: true)
                            return
                        }
                    }
                }

                continuation.resume(returning: false)
            }
        }
    }
}
