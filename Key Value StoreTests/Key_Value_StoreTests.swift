//
//  Key_Value_StoreTests.swift
//  Key Value StoreTests
//
//  Created by Ramon Vasconcelos on 14.11.2022.
//

import XCTest
@testable import Key_Value_Store

class Key_Value_StoreTests: XCTestCase {
    private var viewModel: CommandsViewModel!

    override func setUp() {
        super.setUp()
        viewModel = CommandsViewModel()
    }

    func testSetAndGetValue() {
        let setTransaction = viewModel.process("SET foo 123")!
        viewModel.add(setTransaction)
        let getTransaction = viewModel.process("GET foo")!
        viewModel.add(getTransaction)
        
        XCTAssertEqual("123", viewModel.previousTransactionsOutputs.last ?? "")
    }
    
    func testDeleteValue() {
        let deleteTransaction = viewModel.process("DELETE foo")!
        viewModel.add(deleteTransaction)
        let getTransaction = viewModel.process("GET foo")!
        viewModel.add(getTransaction)
        
        XCTAssertEqual("key not set", viewModel.previousTransactionsOutputs.last ?? "")
    }
    
    func testCountNumberOfValueOccurrences() {
        let setTransaction = viewModel.process("SET foo 123")!
        viewModel.add(setTransaction)
        let set2Transaction = viewModel.process("SET bar 456")!
        viewModel.add(set2Transaction)
        let set3Transaction = viewModel.process("SET baz 123")!
        viewModel.add(set3Transaction)
        let countTransaction = viewModel.process("COUNT 123")!
        viewModel.add(countTransaction)
        
        XCTAssertEqual("2", viewModel.previousTransactionsOutputs.last ?? "")
        
        let count2Transaction = viewModel.process("COUNT 456")!
        viewModel.add(count2Transaction)
        XCTAssertEqual("1", viewModel.previousTransactionsOutputs.last ?? "")
    }
    
    func testCommitTransaction() {
        let beginTransaction = viewModel.process("BEGIN")!
        viewModel.add(beginTransaction)
        let setTransaction = viewModel.process("SET foo 456")!
        viewModel.add(setTransaction)
        let commitTransaction = viewModel.process("COMMIT")!
        viewModel.add(commitTransaction)
        let rollbackTransaction = viewModel.process("ROLLBACK")!
        viewModel.add(rollbackTransaction)
        
        XCTAssertEqual("no transaction", viewModel.previousTransactionsOutputs.last ?? "")

        let getTransaction = viewModel.process("GET foo")!
        viewModel.add(getTransaction)
        
        XCTAssertEqual("456", viewModel.previousTransactionsOutputs.last ?? "")
    }
    
    func testRollbackTransaction() {
        let setTransaction = viewModel.process("SET foo 123")!
        viewModel.add(setTransaction)
        let set2Transaction = viewModel.process("SET bar abc")!
        viewModel.add(set2Transaction)
        let beginTransaction = viewModel.process("BEGIN")!
        viewModel.add(beginTransaction)
        let set3Transaction = viewModel.process("SET foo 456")!
        viewModel.add(set3Transaction)
        let getTransaction = viewModel.process("GET foo")!
        viewModel.add(getTransaction)
        
        XCTAssertEqual("456", viewModel.previousTransactionsOutputs.last ?? "")
        
        let set4Transaction = viewModel.process("SET bar def")!
        viewModel.add(set4Transaction)
        let get2Transaction = viewModel.process("GET bar")!
        viewModel.add(get2Transaction)
        
        XCTAssertEqual("def", viewModel.previousTransactionsOutputs.last ?? "")
        
        let rollbackTransaction = viewModel.process("ROLLBACK")!
        viewModel.add(rollbackTransaction)
        let get3Transaction = viewModel.process("GET foo")!
        viewModel.add(get3Transaction)
        
        XCTAssertEqual("123", viewModel.previousTransactionsOutputs.last ?? "")

        let get4Transaction = viewModel.process("GET bar")!
        viewModel.add(get4Transaction)
        
        XCTAssertEqual("abc", viewModel.previousTransactionsOutputs.last ?? "")
        
        let commitTransaction = viewModel.process("COMMIT")!
        viewModel.add(commitTransaction)

        XCTAssertEqual("no transaction", viewModel.previousTransactionsOutputs.last ?? "")
    }
    
    func testNestedTransactions() {
        let setTransaction = viewModel.process("SET foo 123")!
        viewModel.add(setTransaction)
        let beginTransaction = viewModel.process("BEGIN")!
        viewModel.add(beginTransaction)
        let set2Transaction = viewModel.process("SET bar 456")!
        viewModel.add(set2Transaction)
        let set3Transaction = viewModel.process("SET foo 456")!
        viewModel.add(set3Transaction)
        let begin2Transaction = viewModel.process("BEGIN")!
        viewModel.add(begin2Transaction)
        let countTransaction = viewModel.process("COUNT 456")!
        viewModel.add(countTransaction)
        
        XCTAssertEqual("2", viewModel.previousTransactionsOutputs.last ?? "")

        let getTransaction = viewModel.process("GET foo")!
        viewModel.add(getTransaction)
        
        XCTAssertEqual("456", viewModel.previousTransactionsOutputs.last ?? "")
        
        let set4Transaction = viewModel.process("SET foo 789")!
        viewModel.add(set4Transaction)
        let get2Transaction = viewModel.process("GET foo")!
        viewModel.add(get2Transaction)
        
        XCTAssertEqual("789", viewModel.previousTransactionsOutputs.last ?? "")
        
        let rollbackTransaction = viewModel.process("ROLLBACK")!
        viewModel.add(rollbackTransaction)
        let get3Transaction = viewModel.process("GET foo")!
        viewModel.add(get3Transaction)
        
        XCTAssertEqual("456", viewModel.previousTransactionsOutputs.last ?? "")

        let rollback2Transaction = viewModel.process("ROLLBACK")!
        viewModel.add(rollback2Transaction)
        
        let get4Transaction = viewModel.process("GET foo")!
        viewModel.add(get4Transaction)
        
        XCTAssertEqual("123", viewModel.previousTransactionsOutputs.last ?? "")
    }
}
