// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IPointingContract {
    function getPoints(address user) external view returns (uint256);
}

contract PointingContract {
    mapping(address => uint256) private points;
    
    event PointAdded(address indexed user, uint256 newTotal);
    
    function addPoint() external {
        points[msg.sender] += 1;
        emit PointAdded(msg.sender, points[msg.sender]);
    }
    
    function getPoints(address user) external view returns (uint256) {
        return points[user];
    }
}

contract PrizeClaimContract {
    IPointingContract public pointingContract;
    
    uint256 public constant MINIMUM_POINTS = 50;
    mapping(address => bool) public hasClaimed;
    event PrizeClaimed(address indexed user, uint256 points);
    
    
    constructor(address _pointingContract) {
        require(_pointingContract != address(0), "Invalid contract address");
        pointingContract = IPointingContract(_pointingContract);
    }
    
    function claimPrize() external returns (string memory) {
        require(!hasClaimed[msg.sender], "Prize already claimed");
        uint256 userPoints = pointingContract.getPoints(msg.sender);
        require(userPoints >= MINIMUM_POINTS, "Not enough points to claim prize");
        
        hasClaimed[msg.sender] = true;
       
        emit PrizeClaimed(msg.sender, userPoints);
        
        return "You have claimed your prize!";
    }
    
    function checkEligibility(address user) external view returns (
        bool eligible, 
        uint256 points, 
        bool alreadyClaimed
    ) {
        points = pointingContract.getPoints(user);
        alreadyClaimed = hasClaimed[user];
        eligible = points >= MINIMUM_POINTS && !alreadyClaimed;
    }
}