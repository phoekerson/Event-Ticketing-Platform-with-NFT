// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./Mytoken.sol";

/**
 * @title TokenFactory - Factory contract to deploy ERC20 tokens
 * @dev Allows users to deploy their own instances of MyToken
 */
contract TokenFactory {
    // Array to store all deployed token addresses
    address[] public deployedTokens;
    
    // Mapping to track tokens deployed by each user
    mapping(address => address[]) public userTokens;
    
    // Mapping to check if an address is a token deployed by this factory
    mapping(address => bool) public isFactoryToken;
    
    // Events
    event TokenDeployed(
        address indexed tokenAddress,
        address indexed creator,
        string name,
        string symbol,
        uint256 initialSupply
    );
    
    /**
     * @dev Deploy a new MyToken contract
     * @param _name Name of the token
     * @param _symbol Symbol of the token
     * @param _initialSupply Initial supply of tokens (in tokens, not wei)
     * @param _owner Owner of the new token (can be different from deployer)
     * @return tokenAddress Address of the newly deployed token
     */
    function deployToken(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply,
        address _owner
    ) public returns (address tokenAddress) {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(bytes(_symbol).length > 0, "Symbol cannot be empty");
        require(_owner != address(0), "Owner cannot be zero address");
        
        // Convert initial supply to wei (18 decimals)
        uint256 initialSupplyWei = _initialSupply * 10**18;
        
        // Deploy new token contract
        MyToken newToken = new MyToken(_name, _symbol, initialSupplyWei, _owner);
        tokenAddress = address(newToken);
        
        // Store the deployed token
        deployedTokens.push(tokenAddress);
        userTokens[msg.sender].push(tokenAddress);
        isFactoryToken[tokenAddress] = true;
        
        emit TokenDeployed(tokenAddress, msg.sender, _name, _symbol, initialSupplyWei);
        
        return tokenAddress;
    }
    
    /**
     * @dev Deploy a token with the caller as owner
     * @param _name Name of the token
     * @param _symbol Symbol of the token
     * @param _initialSupply Initial supply of tokens (in tokens, not wei)
     * @return tokenAddress Address of the newly deployed token
     */
    function deployTokenForSelf(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply
    ) public returns (address tokenAddress) {
        return deployToken(_name, _symbol, _initialSupply, msg.sender);
    }
    
    /**
     * @dev Get the total number of tokens deployed by this factory
     * @return count Total number of deployed tokens
     */
    function getDeployedTokensCount() public view returns (uint256 count) {
        return deployedTokens.length;
    }
    
    /**
     * @dev Get all tokens deployed by this factory
     * @return tokens Array of all deployed token addresses
     */
    function getAllDeployedTokens() public view returns (address[] memory tokens) {
        return deployedTokens;
    }
    
    /**
     * @dev Get tokens deployed by a specific user
     * @param _user Address of the user
     * @return tokens Array of token addresses deployed by the user
     */
    function getUserTokens(address _user) public view returns (address[] memory tokens) {
        return userTokens[_user];
    }
    
    /**
     * @dev Get the number of tokens deployed by a specific user
     * @param _user Address of the user
     * @return count Number of tokens deployed by the user
     */
    function getUserTokensCount(address _user) public view returns (uint256 count) {
        return userTokens[_user].length;
    }
    
    /**
     * @dev Get basic information about a deployed token
     * @param _tokenAddress Address of the token
     * @return name Token name
     * @return symbol Token symbol
     * @return totalSupply Total supply of the token
     * @return owner Owner of the token
     */
    function getTokenInfo(address _tokenAddress) public view returns (
        string memory name,
        string memory symbol,
        uint256 totalSupply,
        address owner
    ) {
        require(isFactoryToken[_tokenAddress], "Token not deployed by this factory");
        
        MyToken token = MyToken(_tokenAddress);
        return (
            token.name(),
            token.symbol(),
            token.totalSupply(),
            token.owner()
        );
    }
    
    /**
     * @dev Check if a token was deployed by this factory
     * @param _tokenAddress Address to check
     * @return isFactory True if the token was deployed by this factory
     */
    function isTokenFromFactory(address _tokenAddress) public view returns (bool isFactory) {
        return isFactoryToken[_tokenAddress];
    }
}