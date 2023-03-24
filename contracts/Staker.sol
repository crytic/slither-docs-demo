pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Staker {
    mapping(address => uint256) internal stakedBalances;
    IERC20 public tokenToStake;

    constructor(address _tokenToStake) {
        tokenToStake = IERC20(_tokenToStake);
    }

    function stake(uint256 amount) public returns(uint256 stakedAmount) {
        // This is not safe, use safeTransferFrom
        bool success = tokenToStake.transferFrom(msg.sender, address(this), amount);
        require(success == true, "transferFrom failed");

        // The exchange rate of token to staked token is 1:1
        stakedAmount = amount;
        // Update the balance of the sender
        stakedBalances[msg.sender] += stakedAmount;
    }

    function unstake(uint256 stakedAmount) public returns(uint256 amount) {
        // Make sure msg.sender has staked more than stakedAmount
        require(stakedBalances[msg.sender] >= stakedAmount, "Cannot unstake more than you have");
        // Update the balance of the sender
        stakedBalances[msg.sender] -= stakedAmount;
        // You get back what you deposited
        amount = stakedAmount;
        bool success = tokenToStake.transfer(msg.sender, amount);
        require(success == true, "transfer failed");
    }
    
    function getStakedBalances(address user) public returns(uint256 stakedAmount) {
        return stakedBalances[user];
    }
}
