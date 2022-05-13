// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//imoorting ERC20 token contract from OpenZeppelin;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
//declaring my contract
contract AfroCoin is ERC20{
    //calling a constructor from the contract which takes the name and symbol of the token;
    constructor(uint256 initialSupply) ERC20("Afrocoin", "AC") {
        _mint(msg.sender, initialSupply);
    }

}
//Another method without hardcoding;
contract HalittaToken is ERC20 {
    //I am calling the constructor without hardcoding the name and symbol of the coin;
    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        //calling mint function from the ERC20 contract and hardcodding the total supply to 1000 token;
       _mint(msg.sender, 1000 * (10 ** 18));
    }
}
