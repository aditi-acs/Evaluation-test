// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";


// defining smart contract erc20 token which is burnable and ownable
contract StudentRecords is ERC20, ERC20Burnable, Ownable, ERC20Permit {
    constructor() ERC20("Records", "MTK") ERC20Permit("Records") {}

    // token supply initialisation upto 8 decimals value (1mil)
    uint8  decimals = 8;
    uint256 totalSupply = 1000000 * 10**uint256(decimals);
    
     // defining receive and send events for the token address
    event TransferReceived(address _from, uint _amount);
    event TransferSent(address _from, address _destAddr, uint _amount);
    
    // initialising Student struct 
    struct Student
    {
        int ID;
        string fName;
        int marks;
        bool ispresent;
    }
    
    // Student struct mapping to address
    mapping(address => Student) private students;


    // function to add record of student to blockchain
    function add_rec(address studentAddress,int ID, string memory fName,int marks) public onlyOwner () {


        // if any Student's record is already present data won't be added twice, for unique ID only record will be added
        require(students[studentAddress].ispresent == false, "Enrollment exists");
            students[studentAddress] = Student(ID, fName, marks, true);
    
    }
    
    // to add marks to previously existing marks of a student
    function add_marks(address studentAddress, int ID, int newmarks) public onlyOwner () {

        Student storage student = students[studentAddress];
        require(student.ID != 0, "Student does not exist");
        student.marks += newmarks;

    }

    // to give tokens to students as rewards 
    function rewardToken(address studentAddress) public onlyOwner () {

        Student storage student = students[studentAddress];
        require(student.ID != 0, "Student does not exist");

        // to calculate percentage of marks
        uint percent = uint(student.marks) * 100 / 500;
        
        // awarding 5 times of marks as tokens reward 
        uint reward = (percent) * 20 ;
    }
            

    // to transfer erc20 tokens from owner to another address
    function tokentransfer(address _to, uint256 _value) public returns (bool success) {

        _transfer(msg.sender, _to, _value);
        return true;
    } 
    

    

    // to get token balance of smart contract deployed
    function getBalance(address _address) public view returns (uint) {
        return _address.balance;
    }
   
  }



