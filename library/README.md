# Library Management Smart Contract

### Objective :
A simple solidity project simulating a digital library system with a few actual featurs.

---

## Features
-  Add new books (only the owner can do this)
-  Borrow books if available
-  Return borrowed books
-  View all available books
-  Tracks which user borrowed which book

---

##  Function Explanations

1. addBook() : Adds a new book to the library.

2. borrowBook() ; Lets a user borrow a book if it’s available.

3. returnBook() : Returns the borrowed book and makes it available again.

4. getAvailableBooks() : Fetches a list of all currently available books in the library.

5. borrowedBy() : Displays who currently borrowed a specific book.