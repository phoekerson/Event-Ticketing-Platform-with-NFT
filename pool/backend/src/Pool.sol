// SPDX-License-Identifer: MIT
pragma solidity 0.8.30;

/// @title Pool
/// @author Caleb MINTOUMBA (Phoekerson)
import "@openzeppelin/contracts/access/Ownable.sol";
error CollectIsFinished();
error GoalAlreadyReached();
error CollectNotFinished();
error FailedToSendEther();
error NoContribution();
error NotEnoughFunds();

contract Pool is Ownable{
    uint256 public end;
    uint256 public goal;
    uint256 public totalCollected;

    mapping(address => uint256) public contributions;
    event Contribute(address indexed contributor, uint256 amount);

    constructor(uint256 _duration, uint256 _goal) Ownable(msg.sender){
        end = block.timestamp + _duration;
        goal = _goal;
    }
    /// @notice La fonction qui permet de contribuer à la cagnotte
    function contribute() external payable{
        if(block.timestamp >= end){
            revert CollectIsFinished();
        }
        if(msg.value == 0){
            revert NotEnoughFunds();
        }
        contributions[msg.sender] += msg.value;
        totalCollected += msg.value;

        emit Contribute(msg.sender, msg.value);
    }
}
