// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "base64-sol/base64.sol";
import "hardhat/console.sol";

contract MyEpicNFT is ERC721URIStorage {
    string[] private firstWords = [
        "Minty",
        "Flirty",
        "Smelly",
        "Colorful",
        "Blurred",
        "Fantastic",
        "Clad",
        "Fruitful",
        "Glorious",
        "Zestful",
        "Fancy",
        "Acidic",
        "Frosty",
        "Rocky",
        "Jolly",
        "Applicable",
        "Quilted"
    ];

    string[] private secondWords = [
        "Red",
        "Blue",
        "Green",
        "Yellow",
        "Purple",
        "Orange",
        "Pink",
        "Brown",
        "White",
        "Black",
        "Gold",
        "Silver",
        "Bronze",
        "Silver",
        "Copper",
        "Platinum",
        "Iron",
        "Steel"
    ];

    string[] private thirdWords = [
        "Cup",
        "Cake",
        "Candy",
        "Cookie",
        "Gerbil",
        "Skunk",
        "Blob",
        "Unicorn",
        "Ghost",
        "Zebra",
        "Pig",
        "Horse",
        "Cow",
        "Sheep",
        "Goat",
        "Lamb",
        "Piglet",
        "Puppy",
        "Kitten",
        "Dragon"
    ];

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("This is my NFT smart contract");
    }

    function makeAnEpicNFT() public {
        // Get the current tokenId
        uint256 tokenId = _tokenIds.current();

        // Mint the NFT to the sender using msg.sender
        _safeMint(msg.sender, tokenId);

        // Generate the SVG and encode it as base64
        string memory tokenPhrase = getRandomPhrase(tokenId);
        console.log("Token phrase: %s", tokenPhrase);
        string memory tokenSvg = generateSvg(tokenPhrase);
        console.log("Token SVG: %s", tokenSvg);
        string memory encodedTokenSvg = Base64.encode(
            abi.encodePacked(tokenSvg)
        );
        console.log("Encoded token SVG: %s", encodedTokenSvg);

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        tokenPhrase,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        encodedTokenSvg,
                        '"}'
                    )
                )
            )
        );

        string memory tokenURI = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(encodedTokenSvg);
        console.log("--------------------\n");

        // Set the NFT data
        _setTokenURI(tokenId, tokenURI);
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            tokenId,
            msg.sender
        );

        _tokenIds.increment();
    }

    function generateSvg (string memory phrase)
        public
        pure
        returns (string memory)
    {
        string
            memory baseSvgfront = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">';
        string memory baseSvgtail = "</text></svg>";

        return string(abi.encodePacked(baseSvgfront, phrase, baseSvgtail));
    }

    function getRandomPhrase(uint256 _randNonce)
        public
        view
        returns (string memory)
    {
        uint256 firstWordIndex = uint256(
            keccak256(abi.encodePacked(_randNonce))
        ) % firstWords.length;
        uint256 secondWordIndex = uint256(
            keccak256(abi.encodePacked(_randNonce))
        ) % secondWords.length;
        uint256 thirdWordIndex = uint256(
            keccak256(abi.encodePacked(_randNonce))
        ) % thirdWords.length;

        string memory firstWord = firstWords[firstWordIndex];
        string memory secondWord = secondWords[secondWordIndex];
        string memory thirdWord = thirdWords[thirdWordIndex];

        return
            string(
                abi.encodePacked(firstWord, " ", secondWord, " ", thirdWord)
            );
    }
}
