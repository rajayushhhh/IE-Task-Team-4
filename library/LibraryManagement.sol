// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LibraryManagement {
    address public owner;

    //struct for our Book
    struct Book {
        uint256 bookId;
        string title;
        string author;
        bool isAvailable;
    }

    // mapping of bookId to Book details
    mapping(uint256 => Book) public books;

    // mapping to get which user borrowed which book
    mapping(uint256 => address) public borrowedBy;

    uint256 public totalBooks;

    // events
    event BookAdded(
        uint256 bookId, 
        string title, 
        string author);
    event BookBorrowed(
        uint256 bookId, 
        address indexed borrower);
    event BookReturned(
        uint256 bookId, 
        address indexed borrower);

    // modifier to restricts access to only the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    // modifier for  availability checks
    modifier validBook(uint256 _bookId) {
        require(_bookId > 0 && _bookId <= totalBooks, "Invalid book ID");
        _;
    }

    constructor() {
        owner = msg.sender; 
    }
    // functions

    // add book
    function addBook(string memory _title, string memory _author) public onlyOwner {
        totalBooks++;
        books[totalBooks] = Book(totalBooks, _title, _author, true);
        emit BookAdded(totalBooks, _title, _author);
    }
    // borrow book
    function borrowBook(uint256 _bookId) public validBook(_bookId) {
        Book storage book = books[_bookId];
        require(book.isAvailable, "Book is not available");
        book.isAvailable = false;
        borrowedBy[_bookId] = msg.sender;
        emit BookBorrowed(_bookId, msg.sender);
    }

    // return book
    function returnBook(uint256 _bookId) public validBook(_bookId) {
        require(borrowedBy[_bookId] == msg.sender, "You didn't borrow this book");
        books[_bookId].isAvailable = true;
        borrowedBy[_bookId] = address(0);
        emit BookReturned(_bookId, msg.sender);
    }

    // get available books
    function getAvailableBooks() public view returns (Book[] memory) {
        uint256 count;
        for (uint256 i = 1; i <= totalBooks; i++) {
            if (books[i].isAvailable) count++;
        }

        Book[] memory available = new Book[](count);
        uint256 index;
        for (uint256 i = 1; i <= totalBooks; i++) {
            if (books[i].isAvailable) {
                available[index] = books[i];
                index++;
            }
        }
        return available;
    }
}
