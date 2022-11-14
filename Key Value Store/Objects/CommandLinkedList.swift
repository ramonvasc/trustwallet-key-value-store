//
//  CommandLinkedList.swift
//  Key Value Store
//
//  Created by Ramon Vasconcelos on 14.11.2022.
//

import Foundation

class CommandLinkedList {
    private var previousCommands: [String: String]
    private var commandsCount: [String: Int]

    private var parent: CommandLinkedList? = nil
    private var child: CommandLinkedList? = nil

    init(previousCommands: [String: String] = [:], commandsCount: [String: Int] = [:], parent: CommandLinkedList? = nil) {
        self.previousCommands = previousCommands
        self.commandsCount = commandsCount
        self.parent = parent
    }
    
    func get(_ key: String) -> String {
        return previousCommands[key] ?? "key not set"
    }
    
    func count(_ value: String) -> String {
        return "\(commandsCount[value] ?? 0)"
    }

    func set(_ key: String, _ value: String) {
        let oldValueKey = previousCommands[key]
        previousCommands[key] = value
        commandsCount[value] = (commandsCount[value] ?? 0) + 1
        
        if let oldValueKey = oldValueKey {
            let oldValueOccurrences = commandsCount[oldValueKey] ?? 0
            if (oldValueOccurrences == 1) {
                commandsCount.removeValue(forKey: oldValueKey)
            } else {
                commandsCount[oldValueKey] = oldValueOccurrences - 1
            }
        }
    }
    
    func delete(_ key: String) {
        let oldValue = previousCommands[key]
        if let oldValue = oldValue {
            commandsCount[oldValue] = (commandsCount[oldValue] ?? 0) - 1
            previousCommands.removeValue(forKey: key)
        }
    }
    
    func rollback() -> CommandLinkedList? {
        parent?.child = nil
        return parent
    }
    
    func begin() -> CommandLinkedList {
        let newList = CommandLinkedList(previousCommands: previousCommands, commandsCount: commandsCount, parent: self)
        child = newList
        return newList
    }
    
    func commit() -> CommandLinkedList? {    
        parent?.previousCommands = previousCommands
        parent?.commandsCount = commandsCount
        parent?.child = nil
        return parent
    }
        
}
