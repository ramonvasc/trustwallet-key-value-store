//
//  CommandsViewModel.swift
//  Key Value Store
//
//  Created by Ramon Vasconcelos on 14.11.2022.
//

import Foundation

class CommandsViewModel: ObservableObject {
    @Published var isTransactionValid: Bool = false
    @Published var previousTransactions: [String] = []
    @Published var previousTransactionsOutputs: [String] = []
    
    private var linkedList: CommandLinkedList = CommandLinkedList()

    func needsToConfirm(_ transaction: Transaction) -> Bool {
        switch transaction {
        case .commit, .rollback, .delete(_):
            return true
        default:
            return false
        }
    }
    
    func add(_ transaction: Transaction) {
        previousTransactions.append(transaction.description)
        var commandOutput = ""
        switch transaction {
        case let .set(key, value):
            linkedList.set(key, value)
        case let .get(key):
            commandOutput = linkedList.get(key)
        case let .delete(key):
            linkedList.delete(key)
        case let .count(value):
             commandOutput = linkedList.count(value)
        case .begin:
            linkedList = linkedList.begin()
        case .commit:
            if let commit = linkedList.commit() {
                linkedList = commit
            } else {
                commandOutput = "no transaction"
            }
        case .rollback:
            if let rollback = linkedList.rollback() {
                linkedList = rollback
            } else {
                commandOutput = "no transaction"
            }
        }
        previousTransactionsOutputs.append(commandOutput)
    }
    
    func clearList() {
        linkedList = CommandLinkedList()
        previousTransactions = []
        previousTransactionsOutputs = []
    }
    
    func process(_ rawTransaction: String) -> Transaction? {
        let transactionArgs = rawTransaction.components(separatedBy: " ")
        guard let command = transactionArgs.first else {
            return nil
        }
        
        switch command.lowercased() {
        case "set":
            if transactionArgs.count != 3 {
                return nil
            }
            return Transaction.set(key: transactionArgs[1], value: transactionArgs[2])
        case "get":
            if transactionArgs.count != 2 {
                return nil
            }
            return Transaction.get(key: transactionArgs[1])
        case "delete":
            if transactionArgs.count != 2 {
                return nil
            }
            return Transaction.delete(key: transactionArgs[1])
        case "count":
            if transactionArgs.count != 2 {
                return nil
            }
            return Transaction.count(value: transactionArgs[1])
        case "begin":
            return Transaction.begin
        case "commit":
            return Transaction.commit
        case "rollback":
            return Transaction.rollback
        default:
            return nil
        }
    }
}
