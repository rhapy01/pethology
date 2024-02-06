// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PetologyToken is ERC20, Ownable(msg.sender) {
    uint256 private constant INITIAL_SUPPLY = 1000000 * 10 ** 18; // 1,000,000 tokens with 18 decimals
    address private gameContractAddress;

    mapping(address => bool) private _minters;

    event MinterAdded(address indexed account);
    event MinterRemoved(address indexed account);

    constructor() ERC20("Petology Token", "PET") {
        _mint(msg.sender, INITIAL_SUPPLY);
        _minters[msg.sender] = true;
    }

    modifier onlyMinter() {
        require(_minters[msg.sender], "Caller is not a minter");
        _;
    }

    function addMinter(address _account) external onlyOwner {
        require(_account != address(0), "Minter address cannot be zero");
        _minters[_account] = true;
        emit MinterAdded(_account);
    }

    function removeMinter(address _account) external onlyOwner {
        require(_minters[_account], "Account is not a minter");
        _minters[_account] = false;
        emit MinterRemoved(_account);
    }

    function mint(address _recipient, uint256 _amount) external onlyMinter {
        _mint(_recipient, _amount);
    }

    function burn(uint256 _amount) external {
        _burn(msg.sender, _amount);
    }

    function burnFrom(address _account, uint256 _amount) external onlyMinter {
        _burn(_account, _amount);
    }

    function setGameContractAddress(address _gameContractAddress) external onlyOwner {
        require(_gameContractAddress != address(0), "Game contract address cannot be zero");
        gameContractAddress = _gameContractAddress;
    }

    function getGameContractAddress() external view returns (address) {
        return gameContractAddress;
    }

    // Additional functions for managing token functionality can be added here
}
