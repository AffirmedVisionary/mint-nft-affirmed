// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

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

    // I concatenate it all together, and then close the <text> and <svg> tags.
    string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, endSvg));
    console.log("\n--------------------");
    console.log(finalSvg);
    console.log("--------------------\n");

     // Actually mint the NFT to the sender using msg.sender.
    _safeMint(msg.sender, newItemId);

    // Set the NFTs data.
    _setTokenURI(newItemId, "data:application/json;base64,ewogICAgIm5hbWUiOiAiT25lUGF0aDNXb3Jkc1N1cGVyIiwKICAgICJkZXNjcmlwdGlvbiI6ICJBbiBORlQgZnJvbSB0aGUgaGlnaGx5IGFjY2xhaW1lZCBBZmZpcm1lZCBWaXNpb25hcnkiLAogICAgImltYWdlIjogImRhdGE6aW1hZ2Uvc3ZnK3htbDtiYXNlNjQsUEhOMlp5QnBaRDBpYzNWd1pYSjNiM0prY3lJZ2VHMXNibk05SW1oMGRIQTZMeTkzZDNjdWR6TXViM0puTHpJd01EQXZjM1puSWlCMmFXVjNRbTk0UFNJd0lEQWdPREV3SURneE1DSWdjMmhoY0dVdGNtVnVaR1Z5YVc1blBTSm5aVzl0WlhSeWFXTlFjbVZqYVhOcGIyNGlJSFJsZUhRdGNtVnVaR1Z5YVc1blBTSm5aVzl0WlhSeWFXTlFjbVZqYVhOcGIyNGlJSE4wZVd4bFBTSmlZV05yWjNKdmRXNWtMV052Ykc5eU9pTXlOREl3TlRnaVBqeHdZWFJvSUdsa1BTSnpkWEJsY25kdmNtUnpMWE10Y0dGMGFERWlJR1E5SWswek9UTXVNalF5SURZM01TNDJOamhoTWpFM0xqQXlJREl4Tnk0d01pQXdJREFnTVNBeE1TNDNNVEV0TGpNME5HTXpMalkzTmlBd0lEY3VOakEyTGpFeU1TQXhNUzQzTURNdU16UTBiQzB4TVM0M01EY3ROamd1TlRVNVdtMHdJREFpSUhSeVlXNXpabTl5YlQwaWRISmhibk5zWVhSbEtEQWdMVEk0TGpZeE5Da2lJR1pwYkd3OUlpTm1ZellpTHo0OGNHRjBhQ0JwWkQwaWMzVndaWEozYjNKa2N5MXpMWEJoZEdneUlpQmtQU0p0TXpVd0xqVTJNeUEyTnpZdU1qRTVJREUzTGpnMU1TMHhNRFF1TlRNMVlURTBMalkxTWlBeE5DNDJOVElnTUNBd0lERXRNVEV1TlRZMklEVXVOalFnTVRRdU5UZ2dNVFF1TlRnZ01DQXdJREV0T0M0eE9USXRNaTQxTVRWakxUa3VNVGMyTFRZdU1qSXRNVFl1TXpBMExURXlMalF3TXkweU1TNDNNRE10TVRndU56YzRMVEl3TGpBME55QTJNQzR4TlRNdE1qZ3VPVFUzSURFeU9TNHlPVE10TWpndU9UVTNJREV5T1M0eU9UTnpNalF1TkRreUxUVXVNRGNnTlRJdU5UWTJMVGt1TVRBMVdtMHdJREFpSUhSeVlXNXpabTl5YlQwaWRISmhibk5zWVhSbEtEQWdMVEk0TGpZeE5Da2lJR1pwYkd3OUlpTm1ZellpTHo0OGNHRjBhQ0JwWkQwaWMzVndaWEozYjNKa2N5MXpMWEJoZEdneklpQmtQU0pOTkRZeExqSTFJRFUzTkM0NE1EbGhNVFF1TlRreklERTBMalU1TXlBd0lEQWdNUzA0TGpFNU5TQXlMalV4TlNBeE5DNDJORFlnTVRRdU5qUTJJREFnTUNBeExURXhMalUzTFRVdU5qUTBiREUzTGpnMU5TQXhNRFF1TlRNNVl6STRMakEzTkNBMExqQXpOU0ExTWk0MU55QTVMakV3TlNBMU1pNDFOeUE1TGpFd05YTXRPQzQ1TVMwMk9TNHhOQzB5T0M0NU5pMHhNamt1TWprell5MDFMalF3TXlBMkxqTTRNeTB4TWk0MU16SWdNVEl1TlRZM0xUSXhMamNnTVRndU56YzRXbTB3SURBaUlIUnlZVzV6Wm05eWJUMGlkSEpoYm5Oc1lYUmxLREFnTFRJNExqWXhOQ2tpSUdacGJHdzlJaU5tWXpZaUx6NDhjR0YwYUNCcFpEMGljM1Z3WlhKM2IzSmtjeTF6TFhCaGRHZzBJaUJrUFNKTk5EWXlMalExSURVek5DNDNNamRqTWk0NU5DMDBMakU0T0NBekxqTTBNeTAyTGpZMklETXVNell6TFRndU16UTBMUzR3TURndE1pNHdOelF0TGpneU9TMDBMakUwTFRJdU5qWXROaTQyTmpRdE1TNDVNelF0TWk0Mk5UTXROUzR3T1RndE5TNDFPRFl0T0M0NU1EY3RPQzR5TlRSaE5qUXVNRGNnTmpRdU1EY2dNQ0F3SURBdE1TNHpNVFl0TGprd00yd3RPUzQyTkRrZ05ERXVNVFE1WVRFMUxqRXdOU0F4TlM0eE1EVWdNQ0F3SURFZ01TNDFOVEV0TVM0eU1EZGpNVEF1TVRrMUxUWXVPRGM1SURFMUxqSXdNeTB4TWk0ek56VWdNVGN1TmpFM0xURTFMamMzTjFwdE1DQXdJaUIwY21GdWMyWnZjbTA5SW5SeVlXNXpiR0YwWlNnd0lDMHlPQzQyTVRRcElpQm1hV3hzUFNJalptTTJJaTgrUEhCaGRHZ2dhV1E5SW5OMWNHVnlkMjl5WkhNdGN5MXdZWFJvTlNJZ1pEMGlUVE0wTmk0NU5UTWdOVEU1TGpRME5XTXRNUzQ1T0NBeUxqWTBMVEl1T0RZZ05DNDNPRFV0TWk0NE5qY2dOaTQ1TnpjdU1ESXpJREV1TmpRMExqUXlOaUEwTGpFeE55QXpMak0zTVNBNExqTXhNaUF5TGpRd05pQXpMak01TlNBM0xqUXhPQ0E0TGpnNU5TQXhOeTQyTVNBeE5TNDNOall1TlRVdU16YzFJREV1TURjdU56Z3hJREV1TlRVNElERXVNakUxYkMwNUxqWTFNaTAwTVM0eE5UTmpMVFF1TXpRMElESXVPVEl5TFRjdU9UY2dOaTR4TWpJdE1UQXVNRElnT0M0NE9ETmFiVEFnTUNJZ2RISmhibk5tYjNKdFBTSjBjbUZ1YzJ4aGRHVW9NQ0F0TWpndU5qRTBLU0lnWm1sc2JEMGlJMlpqTmlJdlBqeHdZWFJvSUdsa1BTSnpkWEJsY25kdmNtUnpMWE10Y0dGMGFEWWlJR1E5SWswME1URXVOelUwSURReE1TNDNPVE5oTXpBdU1UQTJJRE13TGpFd05pQXdJREFnTVNBNExqRTROQ0F6TGpJek5DQXpNUzQyT1RVZ016RXVOamsxSURBZ01DQXhJREl1TkRjeUlERXVOVGswSURNeExqVTBNaUF6TVM0MU5ESWdNQ0F3SURFZ01pNHpNRFVnTVM0NE1qZ2dNamt1TnpneUlESTVMamM0TWlBd0lEQWdNU0EwTGpBeE5pQTBMakk1TXlBeU9TNDFORFFnTWprdU5UUTBJREFnTUNBeElETXVNVEExSURRdU9Ua3lZeTQwTXpRdU9EZ3VPREkwSURFdU56Z3lJREV1TVRjeUlESXVOMkV6TUM0eE5qY2dNekF1TVRZM0lEQWdNQ0F4SURFdU5USWdOUzQyT0dNdU1UWXVPVFk0TGpJM015QXhMamswTGpNMElESXVPVEl4TGpBMk1pNDVPQzR3TnpjZ01TNDVOakV1TURRMklESXVPVFExWVRJNUxqVTRPQ0F5T1M0MU9EZ2dNQ0F3SURFdExqYzJOaUExTGpneU9TQXpNQzQzT0RrZ016QXVOemc1SURBZ01DQXhMUzQ0TURRZ01pNDRNeklnTWprdU9UY2dNamt1T1RjZ01DQXdJREV0TWk0ME1qWWdOUzR6TlRVZ01qZ3VNek01SURJNExqTXpPU0F3SURBZ01TMHhMalU1TkNBeUxqUTNNeUF5T1M0M09UZ2dNamt1TnprNElEQWdNQ0F4TFRNdU9EY3hJRFF1TkRJeUlESTVMamMzTXlBeU9TNDNOek1nTUNBd0lERXROQzQyTmlBekxqVTRNaUF6TUM0d05UZ2dNekF1TURVNElEQWdNQ0F4TFRndU1EY2dNeTQxTURRZ016QXVNVE16SURNd0xqRXpNeUF3SURBZ01TMDRMamN6T1NBeExqQXdOeUF6TUM0NE1UWWdNekF1T0RFMklEQWdNQ0F4TFRJdU9UTXpMUzR5TXpnZ016QXVNRGdnTXpBdU1EZ2dNQ0F3SURFdE1URXVNRGMwTFRNdU56WXlJREk0TGpNek9TQXlPQzR6TXprZ01DQXdJREV0TWk0ME56TXRNUzQxT1RNZ01qa3VOVFkzSURJNUxqVTJOeUF3SURBZ01TMDBMalF4T0MwekxqZzNOU0F5T1M0M01qSWdNamt1TnpJeUlEQWdNQ0F4TFRNdU5UYzRMVFF1TmpZMElESTVMalEzTmlBeU9TNDBOellnTUNBd0lERXRNUzQwTXkweUxqVTNJRE13TGpZM015QXpNQzQyTnpNZ01DQXdJREV0TVM0eE56SXRNaTQzTURRZ016QXVNelEwSURNd0xqTTBOQ0F3SURBZ01TMHhMalV5TFRVdU5qYzJJRE13TGpjM05DQXpNQzQzTnpRZ01DQXdJREV0TGpNMExUSXVPVEkxSURNeExqQTBOaUF6TVM0d05EWWdNQ0F3SURFdExqQTBOaTB5TGprME1pQXlPUzQySURJNUxqWWdNQ0F3SURFZ0xqSXpPQzB5TGprek15QXpNQzR5TXpnZ016QXVNak00SURBZ01DQXhJREV1TXpNeUxUVXVOekkzWXk0ek1UY3RMamt6TkM0Mk56WXRNUzQ0TkRRZ01TNHdPREl0TWk0M016aGhNamt1TVRVZ01qa3VNVFVnTUNBd0lERWdNUzR6TkRRdE1pNDJNakVnTWprdU9EZ2dNamt1T0RnZ01DQXdJREVnTVM0MU9TMHlMalEzTXlBek1TNDFORElnTXpFdU5UUXlJREFnTUNBeElERXVPREk0TFRJdU16QTFZeTQyTkRrdExqY3pPQ0F4TGpNek1pMHhMalEwTlNBeUxqQTBOeTB5TGpFeE4zTXhMalEyTlMweExqTXdOU0F5TGpJME1pMHhMamt3Tm1Fek1DNHlOeUF6TUM0eU55QXdJREFnTVNBeUxqUXhPQzB4TGpZM05pQXpNQzQxTkNBek1DNDFOQ0F3SURBZ01TQXlMalUzTFRFdU5ETWdNekV1TVRFZ016RXVNVEVnTUNBd0lERWdNaTQzTFRFdU1UY3lJRE13TGpNME5DQXpNQzR6TkRRZ01DQXdJREVnTWk0NExTNDRPVGdnTWprdU16VTFJREk1TGpNMU5TQXdJREFnTVNBMUxqYzVOeTB1T1RZZ01qa3VOVFl6SURJNUxqVTJNeUF3SURBZ01TQTFMamczTVM0eE9XTXVPVGMzTGpFeklERXVPVFF5TGpNd01TQXlMamc1TlM0MU1qUmFiVEFnTUNJZ2RISmhibk5tYjNKdFBTSjBjbUZ1YzJ4aGRHVW9NQ0F0TWpndU5qRTBLU0lnWm1sc2JEMGlJMlpqTmlJdlBqeDBaWGgwSUdsa1BTSnpkWEJsY25kdmNtUnpMWE10ZEdWNGRERWlJR1I0UFNJd0lpQmtlVDBpTUNJZ1ptOXVkQzFtWVcxcGJIazlJaVp4ZFc5ME8zTjFjR1Z5ZDI5eVpITTZPanBUYkdGaWJ5QXlOM0I0Sm5GMWIzUTdJaUJtYjI1MExYTnBlbVU5SWpZeUlpQm1iMjUwTFhkbGFXZG9kRDBpTkRBd0lpQjBjbUZ1YzJadmNtMDlJblJ5WVc1emJHRjBaU2d4TXpVdU1qTXhJREl3T1M0NE9ETXBJaUJtYVd4c1BTSWpabU0ySWlCemRISnZhMlV0ZDJsa2RHZzlJakFpUGp4MGMzQmhiaUJwWkQwaWMzVndaWEozYjNKa2N5MXpMWFJ6Y0dGdU1TSWdlVDBpTUNJZ1ptOXVkQzEzWldsbmFIUTlJalF3TUNJZ2MzUnliMnRsTFhkcFpIUm9QU0l3SWo0OElWdERSRUZVUVZ0WGFHOXNlVXh2ZG1sdVoxQmhjbUZrYVhObFhWMCtQQzkwYzNCaGJqNDhMM1JsZUhRK1BITjBlV3hsUGtCbWIyNTBMV1poWTJWN1ptOXVkQzFtWVcxcGJIazZKbUZ3YjNNN2MzVndaWEozYjNKa2N6bzZPbE5zWVdKdklESTNjSGdtWVhCdmN6czdabTl1ZEMxemRIbHNaVHB1YjNKdFlXdzdabTl1ZEMxM1pXbG5hSFE2TkRBd08zTnlZenAxY213b2FIUjBjSE02THk5bWIyNTBjeTVuYzNSaGRHbGpMbU52YlM5c0wyWnZiblEvYTJsMFBXMUdWREJYWW1kQ2QwdFFVbDlhTkdoSFRqSnhjM2huVW5kQldYRjRUREI2ZFZac1FtaGxkVGRpTFRSM2NFSm5KbUZ0Y0R0emEyVjVQV1pqWmpRNFpqaGxaall4WXpsak5qY21ZVzF3TzNZOWRqRXlLU0JtYjNKdFlYUW9KbUZ3YjNNN2RISjFaWFI1Y0dVbVlYQnZjenNwZlR3dmMzUjViR1UrUEM5emRtYysiCn0=");
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    // Increment the counter for when the next NFT is minted.
    _tokenIds.increment();
  }
}
