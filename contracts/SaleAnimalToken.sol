// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

<<<<<<< HEAD
import "mintAnimalToken.sol";
=======
import "./mintAnimalToken.sol";
>>>>>>> a1cd87186a1182b47922697905d3ae21f84a45cf

contract SaleAnimalToken {
    MintAnimalToken public mintAnimalTokenAddress;

    constructor (address _mintAnimalTokenAddress) {
        mintAnimalTokenAddress = MintAnimalToken(_mintAnimalTokenAddress); // 주소 입력
    }

    mapping(uint256 => uint256) public animalTokenPrices; // 토큰 아이디 입력 시 가격 출력

    uint256[] public onSaleAnimalTokenArray;

    function setForSaleAnimalToken(uint256 _animalTokenId, uint256 _price) public {
        address animalTokenOwner = mintAnimalTokenAddress.ownerOf(_animalTokenId); // 소유자가 판매등록 가능하도록
    

    require(animalTokenOwner == msg.sender, "Caller is not animal token owner."); // 소유자가 실행자와 같으면 통과 아니면 메세지
    require(_price > 0, "Price is zero or lower."); // 값이 0보다 큰지
    require(animalTokenPrices[_animalTokenId] == 0, "This animal token is already on sale."); // 토큰 값이 0원이면 통과 아니면 값이 있다는 것이고 이미 판매되고 있다는 것
    require(mintAnimalTokenAddress.isApprovedForAll(animalTokenOwner, address(this)), "Animal token owner did not approve token."); // 소유자가 판매계약서에 토큰을 보냈는지 확인
    
    animalTokenPrices[_animalTokenId] = _price;
    }

    function purchaseAnimalToken(uint256 _animalTokenId) public payable {  //구매 함수
        uint256 price = animalTokenPrices[_animalTokenId]; // 가격 대입
        address animalTokenOwner = mintAnimalTokenAddress.ownerOf(_animalTokenId); //소유자 주소값 불러옴

        require(price > 0, "Animal token not sale."); //0보다 크면 판매 등록중, 0이하는 판매등록이 되어있지 않음
        require(price <= msg.value, "Caller sent lower than price."); // 보내는 값이 가격보다 크거나 같아야 함.
        require(animalTokenOwner != msg.sender, "Caller is animal token owner."); // 소유자가 아닐 때만 통과

        payable(animalTokenOwner).transfer(msg.value); // 이 함수를 실행한 msg.sender의 msg.value만큼이 토큰 주인에게 감
        mintAnimalTokenAddress.safeTransferFrom(animalTokenOwner, msg.sender, _animalTokenId); // nft 카드는 지불자에게 전달 토큰 소유자, 구매자, 토큰 아이디

        animalTokenPrices[_animalTokenId] = 0; // 토큰 가격을 0원으로 변경

        for(uint256 i = 0; i < onSaleAnimalTokenArray.length; i++) {
            if(animalTokenPrices[onSaleAnimalTokenArray[i]] == 0) { // 판매중인 토큰 중 가격이 0원일 경우
                onSaleAnimalTokenArray[i] = onSaleAnimalTokenArray[onSaleAnimalTokenArray.length -1 ]; // 제일 뒤에 있는 애를 0원인 토큰으로 덮어쓰고
                onSaleAnimalTokenArray.pop(); //제일 뒤에 있는 애를 제거
            }

        }

    }
    function getOnSaleAnimalTokenArrayLength() view public returns (uint256) { // 판매중인 토큰 배열의 길이를 출력하는 함수
        return onSaleAnimalTokenArray.length; // 길이를 통해서 판매중 리스트 for문으로 리스트 가져오면 됨
    }
}