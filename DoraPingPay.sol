pragma solidity ^0.4.24;

contract Consortium { 
    
    mapping (address => uint) private balances;

    address public owner;
    uint totalMembers;
    uint public minimumStakeRequired = 1000000; 
    event LogDepositMade(address accountAddress, uint amount);

    struct Community {
        address owner;
        uint amount;
    }

    mapping(address => Community) communitys;
    
    Community[] members;
   
    function Consortium() public {
        owner = msg.sender;
    }

    /// @notice Deposit stake into Consortium
   
    function depositStake() public payable returns (uint) {
        require( msg.value >= minimumStakeRequired );
        require((balances[msg.sender] + msg.value) >= balances[msg.sender]);

        balances[msg.sender] += msg.value;
       
        LogDepositMade(msg.sender, msg.value); // fire event
       
         totalMembers =  members.push(
            Community({
                amount: msg.value,
                owner: msg.sender
            }) 
        );
        return balances[msg.sender];
    }
    
    function isMember(address addr) constant public returns (bool) {
        bool flag = false;
        for(uint i = 0;i < members.length; i++) {
            if(members[i].owner == addr){
                flag = true;
                break;
            }
        }
        return flag;
    }

    function withdraw(uint withdrawAmount) public returns (uint remainingBal) {
        require(withdrawAmount <= balances[msg.sender]);
        balances[msg.sender] -= withdrawAmount;
        msg.sender.transfer(withdrawAmount);

        return balances[msg.sender];
    }

    function balance() constant public returns (uint) {
        return balances[msg.sender];
    }
}