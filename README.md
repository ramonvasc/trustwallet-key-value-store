# [Mobile] Transactional Key Value Store - TrustWallet
The assignment is to build an interactive interface (using SwiftUI) to a transactional key value store. A user should be able to compile and run this program and get an interactive interface where they can select commands and textfield to enter command value. The user can enter commands to set/get/delete key/value pairs and count values. All values can be treated as strings, no need to differentiate by type. The key/value data only needs to exist in memory for the session, it does not need to be written to disk. It’s better to provide extendable solution.
The interface should also allow the user to perform operations in transactions, which allows the user to commit or roll back their changes to the key value store. That includes the ability to nest transactions and roll back and commit within nested transactions. The solution shouldn't depend on any third party libraries. The interface should support the following commands:

```
SET <key> <value> // store the value for key
GET <key> // return the current value for key
DELETE <key> // remove the entry for key
COUNT <value> // return the number of keys that have the given value
BEGIN // start a new transaction
COMMIT // complete the current transaction
ROLLBACK // revert to state prior to BEGIN call
```

The interface should be easily tested and extended. Interface should show alerts to confirm COMMIT, ROLLBACK or DELETE.

# Examples

## Set and get a value:
```
> SET foo 123
> GET foo
123
```

## Delete a value
```
> DELETE foo
> GET foo
key not set
```

## Count the number of occurrences of a value
```
> SET foo 123
> SET bar 456
> SET baz 123
> COUNT 123
2
> COUNT 456 
1
```

## Commit a transaction
```
> BEGIN
> SET foo 456
> COMMIT
> ROLLBACK
no transaction
> GET foo
456
```

## Rollback a transaction
```
> SET foo 123
> SET bar abc
> BEGIN
> SET foo 456
> GET foo
456
> SET bar def
> GET bar
def
> ROLLBACK
> GET foo
123
> GET bar
abc
 > COMMIT
no transaction
```

## Nested transactions
```
> SET foo 123
> BEGIN
> SET bar 456
> SET foo 456
> BEGIN
> COUNT 456
2
> GET foo
456
> SET foo 789
> GET foo
789
> ROLLBACK
> GET foo
456
> ROLLBACK
> GET foo
123
```
