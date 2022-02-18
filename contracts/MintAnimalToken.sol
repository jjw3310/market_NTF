// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";


contract MintAnimalToken is ERC721Enumerable {
    constructor() ERC721("h662Animals", "HAS") {}

    mapping(uint256 => uint256) animalTypes; // anymaltokenId -> animaltype



    function mintAnimalToken() public { // 유일값 민팅
        uint256 animalTokenId = totalSupply() + 1; // 토큰아이디 + 1 해서 고유값

        uint256 animalType = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, animalTokenId))) % 5 + 1; // 랜덤으로 타입 저장

        animalTypes[animalTokenId] = animalType; 

    _mint(msg.sender, animalTokenId); // ERC721에서 지원되는 민팅함수
    }
}
