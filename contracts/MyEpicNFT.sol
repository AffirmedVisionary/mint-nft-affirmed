// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract MyEpicNFT is ERC721URIStorage {
  // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
  // So, we make a baseSvg variable here that all our NFTs can use.
  string baseSvg = "<svg id='superwords' xmlns='http://www.w3.org/2000/svg' viewBox='0 0 810 810' shape-rendering='geometricPrecision' text-rendering='geometricPrecision' style='background-color:#242058'><path id='superwords-s-path1' d='M393.242 671.668a217.02 217.02 0 0 1 11.711-.344c3.676 0 7.606.121 11.703.344l-11.707-68.559Zm0 0' transform='translate(0 -28.614)' fill='#fc6'/><path id='superwords-s-path2' d='m350.563 676.219 17.851-104.535a14.652 14.652 0 0 1-11.566 5.64 14.58 14.58 0 0 1-8.192-2.515c-9.176-6.22-16.304-12.403-21.703-18.778-20.047 60.153-28.957 129.293-28.957 129.293s24.492-5.07 52.566-9.105Zm0 0' transform='translate(0 -28.614)' fill='#fc6'/><path id='superwords-s-path3' d='M461.25 574.809a14.593 14.593 0 0 1-8.195 2.515 14.646 14.646 0 0 1-11.57-5.644l17.855 104.539c28.074 4.035 52.57 9.105 52.57 9.105s-8.91-69.14-28.96-129.293c-5.403 6.383-12.532 12.567-21.7 18.778Zm0 0' transform='translate(0 -28.614)' fill='#fc6'/><path id='superwords-s-path4' d='M462.45 534.727c2.94-4.188 3.343-6.66 3.363-8.344-.008-2.074-.829-4.14-2.66-6.664-1.934-2.653-5.098-5.586-8.907-8.254a64.07 64.07 0 0 0-1.316-.903l-9.649 41.149a15.105 15.105 0 0 1 1.551-1.207c10.195-6.879 15.203-12.375 17.617-15.777Zm0 0' transform='translate(0 -28.614)' fill='#fc6'/><path id='superwords-s-path5' d='M346.953 519.445c-1.98 2.64-2.86 4.785-2.867 6.977.023 1.644.426 4.117 3.371 8.312 2.406 3.395 7.418 8.895 17.61 15.766.55.375 1.07.781 1.558 1.215l-9.652-41.153c-4.344 2.922-7.97 6.122-10.02 8.883Zm0 0' transform='translate(0 -28.614)' fill='#fc6'/><path id='superwords-s-path6' d='M411.754 411.793a30.106 30.106 0 0 1 8.184 3.234 31.695 31.695 0 0 1 2.472 1.594 31.542 31.542 0 0 1 2.305 1.828 29.782 29.782 0 0 1 4.016 4.293 29.544 29.544 0 0 1 3.105 4.992c.434.88.824 1.782 1.172 2.7a30.167 30.167 0 0 1 1.52 5.68c.16.968.273 1.94.34 2.921.062.98.077 1.961.046 2.945a29.588 29.588 0 0 1-.766 5.829 30.789 30.789 0 0 1-.804 2.832 29.97 29.97 0 0 1-2.426 5.355 28.339 28.339 0 0 1-1.594 2.473 29.798 29.798 0 0 1-3.871 4.422 29.773 29.773 0 0 1-4.66 3.582 30.058 30.058 0 0 1-8.07 3.504 30.133 30.133 0 0 1-8.739 1.007 30.816 30.816 0 0 1-2.933-.238 30.08 30.08 0 0 1-11.074-3.762 28.339 28.339 0 0 1-2.473-1.593 29.567 29.567 0 0 1-4.418-3.875 29.722 29.722 0 0 1-3.578-4.664 29.476 29.476 0 0 1-1.43-2.57 30.673 30.673 0 0 1-1.172-2.704 30.344 30.344 0 0 1-1.52-5.676 30.774 30.774 0 0 1-.34-2.925 31.046 31.046 0 0 1-.046-2.942 29.6 29.6 0 0 1 .238-2.933 30.238 30.238 0 0 1 1.332-5.727c.317-.934.676-1.844 1.082-2.738a29.15 29.15 0 0 1 1.344-2.621 29.88 29.88 0 0 1 1.59-2.473 31.542 31.542 0 0 1 1.828-2.305c.649-.738 1.332-1.445 2.047-2.117s1.465-1.305 2.242-1.906a30.27 30.27 0 0 1 2.418-1.676 30.54 30.54 0 0 1 2.57-1.43 31.11 31.11 0 0 1 2.7-1.172 30.344 30.344 0 0 1 2.8-.898 29.355 29.355 0 0 1 5.797-.96 29.563 29.563 0 0 1 5.871.19c.977.13 1.942.301 2.895.524Zm0 0' transform='translate(0 -28.614)' fill='#fc6'/><text id='superwords-s-text1' dx='0' dy='0' font-family='&quot;superwords:::Slabo 27px&quot;' font-size='62' font-weight='400' transform='translate(135.231 209.883)' fill='#fc6' stroke-width='0'><tspan id='superwords-s-tspan1' y='0' font-weight='400' stroke-width='0'>";
  string endSvg = "</tspan></text><style>@font-face{font-family:&apos;superwords:::Slabo 27px&apos;;font-style:normal;font-weight:400;src:url(https://fonts.gstatic.com/l/font?kit=mFT0WbgBwKPR_Z4hGN2qsxgRwAYqxL0zuVlBheu7b-4wpBg&amp;skey=fcf48f8ef61c9c67&amp;v=v12) format(&apos;truetype&apos;)}</style></svg>";

  // I create three arrays, each with their own theme of random words.
  // Pick some random funny words, names of anime characters, foods you like, whatever! 
  string[] firstWords = ["Mystical", "Celestial", "Abundant", "Melodic", "Magic", "Psychic", "Spiritual", "Unique", "Lucky", "Cosmic", "Creative", "Astral", "Intuitive", "Wise", "Smart"];
  string[] secondWords = ["Sunrise", "Aura", "Sapphire", "Flower", "Meadow", "Unicorn", "Mystic", "Goddess", "Songbird", "Dream", "Rainbow", "Warrior", "Butterfly", "Moon", "Light"];
  string[] thirdWords = ["Citrine", "Ruby", "Jasper", "Diamond", "Amethyst", "Pearl", "Onyx", "Quartz", "Earth", "Air", "Water", "Fire", "Sun", "Sodalite", "Lapis"];


  // We need to pass the name of our NFTs token and its symbol.
  constructor() ERC721 ("SquareNFT", "SQUARE") { // nft standard ERC721 https://eips.ethereum.org/EIPS/eip-721
        console.log("This is my first NFT contract. Watch me soar!");
  }

  // I create a function to randomly pick a word from each array.
  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    // I seed the random generator. More on this in the lesson. 
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    // Squash the # between 0 and the length of the array to avoid going out of bounds.
    rand = rand % firstWords.length;
    return firstWords[rand];
  }

  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  function makeAnEpicNFT() public {
    uint256 newItemId = _tokenIds.current();

    // We go and randomly grab one word from each of the three arrays.
    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);
    string memory combinedWord = string(abi.encodePacked(first, second, third));

    string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, endSvg));

    // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(
        string(
            abi.encodePacked(
                "https://nftpreview.0xdev.codes/?code=",
                finalTokenUri
            )
        )
    );
    console.log("--------------------\n");

     // Actually mint the NFT to the sender using msg.sender.
    _safeMint(msg.sender, newItemId);

    // Set the NFTs data.
    _setTokenURI(newItemId, finalTokenUri);

    // Increment the counter for when the next NFT is minted.
    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
  }
}
