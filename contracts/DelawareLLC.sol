// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

contract DelawareLLC is ERC721Enumerable, Ownable {
    struct Registration {
        uint name;
        uint email;
        uint phone;
        uint physicalAddress;
    }

    mapping(uint256 => Registration) public registrations;

    mapping(uint256 => uint) public fileNumber;

    uint256 public fee;

    constructor(uint256 _fee) {
        fee = _fee;
    }

    function register(address payable owner, Registration registration) {
        require(msg.value == fee, "Starting companies is pay to play. Fee is missing.");
        uint256 tokenId = totalSupply();
        require(tokenId < 100, "Sorry, this meme only allows up to 100 companies.");
        
        (bool sent, bytes memory data) = owner.call{value: msg.value}("");
        require(sent, "Failed to send Ether");

        _safeMint(msg.sender, tokenId);
        registrations[tokenId] = registration;
    }

    function setRegistration(uint256 _tokenId, Registration _registration) external {
        require(_isApprovedOrOwner(msg.sender, _tokenId), "Not an owner");
        require(msg.value == fee);

        registrations[_tokenId] = _registration;
    }

    function isActive(uint256 _tokenId) returns (bool) {
        return fileNumber[_tokenId]
    }

    function setFileNumber(uint256 _tokenId, uint _fileNumber) external onlyOwner {
        fileNumber[_tokenId] = _fileNumber;
    }

    function setFee(uint256 _fee) external onlyOwner {
        fee = _fee;
    }
}
