//
//  ContentView.swift
//  Key Value Store
//
//  Created by Ramon Vasconcelos on 14.11.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private(set) var viewModel = CommandsViewModel()
    
    @State private var showingInvalidTransactionAlert = false
    @State private var showingConfirmTransactionAlert = false
    @State private var userCommand: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                ForEach(Transaction.allCases, id: \.self) { transaction in
                    Button(transaction.description) {
                        userCommand = transaction.description
                        addTransaction(userCommand, isConfirmed: false)
                    }
                    .buttonStyle(.bordered)
                }

                HStack {
                    TextField("Enter command(eg: SET foo 123)", text: $userCommand)
                        .textFieldStyle(.roundedBorder)
                    Button("Enter") {
                        addTransaction(userCommand, isConfirmed: false)
                    }
                    .buttonStyle(.bordered)
                }
                HStack {
                    Text("Previous commands")
                    Spacer()
                    Text("Output")
                }
                HStack {
                    Text(viewModel.previousTransactions.joined(separator: "\n"))
                    Spacer()
                    Text(viewModel.previousTransactionsOutputs.joined(separator: "\n"))
                }
                Spacer()
                Button("Clear list") {
                    viewModel.clearList()
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }.alert("Invalid transaction \(userCommand)", isPresented: $showingInvalidTransactionAlert) {
            Button("Ok") {
                showingInvalidTransactionAlert = false
            }
        }.alert("Would you like to execute \(userCommand)?", isPresented: $showingConfirmTransactionAlert) {
            Button("Yes") {
                showingConfirmTransactionAlert = false
                addTransaction(userCommand, isConfirmed: true)
            }
            Button("No") {
                showingConfirmTransactionAlert = false
            }
        }
    }
    
    private func addTransaction(_ rawTransaction: String, isConfirmed: Bool) {
        let parsedTransaction = viewModel.process(rawTransaction)
        
        guard let parsedTransaction = parsedTransaction else {
            showingInvalidTransactionAlert = true
            return
        }
        
        if !isConfirmed, viewModel.needsToConfirm(parsedTransaction) {
            showingConfirmTransactionAlert = true
            return
        }
        
        viewModel.add(parsedTransaction)
        userCommand = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
