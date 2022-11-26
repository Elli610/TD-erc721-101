
pragma solidity ^0.6.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./IExerciceSolution.sol";

contract MyFirstERC721 is ERC721, IExerciceSolution {

    string public nftName;
    string public nftSymbol;

    constructor() ERC721("Nathan's NFT", "2NFT") public {
        _mint(0x40aDC5976f6ae451Dbf9a390d31c7ffB5366b229, 1) ; //q1 
        //_mint(0x40aDC5976f6ae451Dbf9a390d31c7ffB5366b229c, 4) ;
        //_mint(0x40aDC5976f6ae451Dbf9a390d31c7ffB5366b229, 5) ;
        _mint(0x40aDC5976f6ae451Dbf9a390d31c7ffB5366b229, 2) ;
        //_mint(msg.sender, 6) ;
        //_mint(msg.sender, 3) ;
        //_mint(msg.sender, 7) ;
        //reproduction[6] = 0x0E4F5184E6f87b5F959aeE5a09a2797e8B1b20E5;
        breeder[msg.sender] = true;
        mlegs[2] = 4;
        msex[2] = 1;
        mwings[2] = false;
        mname[2] = "0x7Wjtk-v5Y5h1X";
    }

    mapping(address => bool) breeder;

    function isBreeder(address account) external override returns (bool) {
        return breeder[account];
    }

    function registrationPrice() external override returns (uint256) {
        return 1;
    }

    function registerMeAsBreeder() external payable override {
        require(msg.value == 1, "You must pay 1 wei to register as a breeder");
        breeder[msg.sender] = true;
    }

    mapping(uint256 => string) mname;
    mapping(uint256 => bool) mwings;
    mapping(uint256 => uint) mlegs;
    mapping(uint256 => uint) msex;

    function declareAnimal(uint sex, uint legs, bool wings, string calldata name) external override returns (uint256){
        require(breeder[msg.sender], "You must be a breeder to declare an animal");
        uint256 tokenId = totalSupply() + 1;
        mname[tokenId] = name;
        mwings[tokenId] = wings;
        mlegs[tokenId] = legs;
        msex[tokenId] = sex;
        _mint(msg.sender, tokenId);
        return tokenId;
    }

	function getAnimalCharacteristics(uint256 animalNumber) external override returns (string memory _name, bool _wings, uint _legs, uint _sex){
        require(ownerOf(animalNumber) == msg.sender, "You must be the owner of the animal to get its characteristics");
        return (mname[animalNumber], mwings[animalNumber], mlegs[animalNumber], msex[animalNumber]);
    }

    function declareDeadAnimal(uint animalNumber) external override {
        require(ownerOf(animalNumber) == msg.sender, "You must be the owner of the animal to declare it dead");
        mname[animalNumber] = "";
        mwings[animalNumber] = false;
        mlegs[animalNumber] = 0;
        msex[animalNumber] = 0;
        _burn(animalNumber);
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) public view override(IExerciceSolution, ERC721) returns (uint256){
        return ERC721.tokenOfOwnerByIndex(owner, index);
    }

    mapping(uint256 => bool) forSale;

    function isAnimalForSale(uint animalNumber) external view override returns (bool){
        return forSale[animalNumber];
    }

    mapping(uint256 => uint256) mprice;

    function animalPrice(uint animalNumber) external view override returns (uint256){
        return mprice[animalNumber];
    }

    function buyAnimal(uint animalNumber) external payable override {
        require(forSale[animalNumber], "The animal is not for sale");
        require(msg.value == mprice[animalNumber], "You must pay the price of the animal");
        _transfer(ownerOf(animalNumber), msg.sender, animalNumber);
        forSale[animalNumber] = false;
    }
    
    function offerForSale(uint animalNumber, uint price) external override {
        require(ownerOf(animalNumber) == msg.sender, "You must be the owner of the animal to offer it for sale");
        forSale[animalNumber] = true;
        mprice[animalNumber] = price;
    }

    mapping(uint256 => uint256) mparent1;
    mapping(uint256 => uint256) mparent2;

	function declareAnimalWithParents(uint sex, uint legs, bool wings, string calldata name, uint parent1, uint parent2) external override returns (uint256){
        require(breeder[msg.sender], "You must be a breeder to declare an animal");
        uint256 tokenId = totalSupply() + 1;
        mname[tokenId] = name;
        mwings[tokenId] = wings;
        mlegs[tokenId] = legs;
        msex[tokenId] = sex;
        mparent1[tokenId] = parent1;
        mparent2[tokenId] = parent2;
        _mint(msg.sender, tokenId);
        return tokenId;
    }

    function getParents(uint animalNumber) external override returns (uint256, uint256){
        return (mparent1[animalNumber], mparent2[animalNumber]);
    }

    mapping(uint256 => address) reproduction;

    function canReproduce(uint animalNumber) external override returns (bool){
        return reproduction[animalNumber] == msg.sender;
    }

    mapping(uint256 => uint256) mReproductionPrice;

    function reproductionPrice(uint animalNumber) external view override returns (uint256){
        return mReproductionPrice[animalNumber];
    }

    function offerForReproduction(uint animalNumber, uint priceOfReproduction) external override returns (uint256){
        require(ownerOf(animalNumber) == msg.sender, "You must be the owner of the animal to offer it for reproduction");
        
        return animalNumber + priceOfReproduction;
    }

    mapping(uint256 => address) breederCanReproduce;

    function authorizedBreederToReproduce(uint animalNumber) external override returns (address){
        return breederCanReproduce[animalNumber];
    }

    function payForReproduction(uint animalNumber) external payable override {
        require(ownerOf(animalNumber) == msg.sender, "You must be the owner of the animal to pay for reproduction");
        require(msg.value == mReproductionPrice[animalNumber], "You must pay the price of reproduction");
        reproduction[animalNumber] = msg.sender;
    }


}

