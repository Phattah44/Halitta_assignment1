pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract lottery is VRFConsumerBase {
    //This is a lottery smart where there are going to be players and the owner deploying the contract;
    // it will have global variables of owner and players;
    //it will have functions to enter the game, pick winner, get random number;

    address public owner;
    address payable[] public players;
    uint public lotteryId;

    //since we will be using chainlink VRF we will have to import some contract and global variables;
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;

    constructor()  
    VRFConsumerBase(
            0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, // VRF coordinator
            0x01BE23585060835E02B77ef475b0Cc51aA1e0709  // LINK token address
        ) {
            keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
            fee = 0.1 * 10 ** 18;    // 0.1 LINK

            owner = msg.sender;
            lotteryId = 1;
        }

        modifier onlyOwner(){
            require(msg.sender == owner);
            _;
        }

    function enter(address payable _player) public payable {
        require(msg.value > 0.01 ether);
        players.push(_player);
    }
    /** 
  * Requests randomness from a user-provided seed
  */
    function getRandomNumber() public returns (bytes32 requestId) {
    require(LINK.balanceOf(address(this)) > fee, "Not enough LINK - fill contract with faucet");
    return requestRandomness(keyHash, fee);
    }
    /**
  * Callback function used by VRF Coordinator
  */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
    randomResult = randomness;
    }   
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }
    function pickWinner() public onlyOwner{
        getRandomNumber();
    }
    function payWinner() public {
        uint index = randomResult % players.length;
        players[index].transfer(address(this).balance);

        lotteryId++;
        // reset the state of the contract
        players = new address payable[](0);
    }


}