pragma solidity ^0.4.24;

contract HelloWorld {

    address owner;
    uint public messageCount = 0;
    string public message = "test messgae";
    mapping(uint => string) public messageInfo;


    constructor (string _message) public {
        message = _message;
        owner = msg.sender;
        messageInfo[0] = _message;
    }


    function setMessage (string _message, uint _count) public {
        require(msg.sender == owner, "You are not the owner");
        message = _message;
        messageCount = (_count - _count);
        messageCount += 1;
        messageInfo[messageCount] = _message;
    }



}