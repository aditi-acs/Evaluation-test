// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract MyToken {
    string public name = "My Token";
    string public symbol = "MTK";
    uint8 public decimals = 8;
    uint256 public totalSupply = 1000000 * 10**uint256(decimals);

    mapping (address => uint256) public balanceOf;

    mapping (address => mapping (address => uint256)) public allowance;

    mapping (address => bool) public students;
    mapping (address => uint256) public marks;

    struct Student {
        int ID;
        string fName;
        int marks;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_to != address(0));
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);

        uint256 previousBalances = balanceOf[_from] + balanceOf[_to];

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(_from, _to, _value);

        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function addStudentRecord(address _student, int _ID, string memory _fName) public {
        require(!students[_student]);
        students[_student] = true;
        marks[_student] = 0;
    }

    function addMarks(address _student, uint256 _marks) public {
        require(students[_student]);
        marks[_student] += _marks;
    }

    function rewardTokens(address _student) public {
        require(students[_student]);
        uint256 percentage = (marks[_student] * 10000) / 500; // calculate percentage with 2 decimal places
        uint256 tokensToReward = (percentage * totalSupply) / 10000;
        _transfer(msg.sender, _student, tokensToReward);
    }
}
