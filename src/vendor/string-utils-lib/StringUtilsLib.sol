//SPDX-License-Identifier: MIT

/*
 * @title String Utils Library for Solidity contracts.
 * @author Tega Osowa <https://tega-osowa-portfolio.netlify.app/>
 *
 * @dev This is a comprehensive string utils library for processing and programmatically
 *      working with strings. This library is focused on making the use of strings more
 *      user-friendly, or programmer friendly.
 *
 *      The gas cost for implementing various operations would definitely defer,
 *      depending on the size and length of the string being processed. For large strings,
 *      pre-processing is advised, so as to reduce the gas cost. Operations like toLowerCase,
 *      toUpperCase and isEqualCase, consumes much more gas than other operations, and is
 *      advised to be used wisely, preferably on smaller strings.
 *      All functions are written with simplicity in mind, and should be easy to use and
 *      implement, please feel free to make any request or update for request to me,
 *      it's still a work in progress, and this contribution is important to the Web3 Community.
 *      Code Away
 */

pragma solidity ^0.8.18;

library StringUtilsLib {
    /*
     * @dev Returns an array containing the splitted string.
     * @param text The string to split.
     * @param char The string to split by.
     * @param propsedLength The proposed length of the array.
     * @return A string array.
     */
    function split(
        string memory text,
        string memory char,
        uint256 proposedLength
    ) internal pure returns (string[] memory) {
        text = string.concat(text, char);
        bytes memory nt = bytes(text);
        bytes memory nc = bytes(char);
        string[] memory array = new string[](proposedLength);
        uint256 pointA = 0;
        uint256 i = 0;
        uint256 visiblePoint = 0;
        while (i < nt.length) {
            bytes memory findBytes = new bytes(nc.length);
            uint256 count = 0;
            for (
                uint256 a = i;
                a <
                (
                    (nc.length > (nt.length - i))
                        ? (nt.length - i)
                        : (i + nc.length)
                );
                a++
            ) {
                findBytes[count] = bytes(text)[a];
                count++;
            }
            string memory find = string(findBytes);
            if (
                keccak256(abi.encodePacked(find)) ==
                keccak256(abi.encodePacked(char))
            ) {
                bytes memory findBytes1 = new bytes(i - pointA);
                uint256 count1 = 0;
                for (uint256 a = pointA; a < i; a++) {
                    findBytes1[count1] = bytes(text)[a];
                    count1++;
                }
                array[visiblePoint] = string(findBytes1);
                visiblePoint++;
                i += nc.length;
                pointA = i;
            } else {
                i += 1;
            }
        }
        string[] memory n_array = new string[](visiblePoint);

        for (uint256 a = 0; a < (visiblePoint); a++) {
            n_array[a] = array[a];
        }
        array = new string[](0);
        return n_array.length > 1 ? n_array : new string[](0);
    }

    /*
     * @dev Returns a bool stating true if the string is included in the text.
     * @param text The string to check.
     * @param search The string to search for.
     * @param propsedLength The proposed length of the array.
     * @return A bool which is true if the string is the text.
     */
    function includes(
        string memory text,
        string memory search
    ) internal pure returns (bool) {
        bytes memory nt = bytes(text);
        bytes memory nc = bytes(search);
        bool exist = false;
        for (uint256 i = 0; i < nt.length; i++) {
            bytes memory findBytes = new bytes(nc.length);
            uint256 count = 0;
            for (uint256 a = i; a < (i + nc.length); a++) {
                findBytes[count] = bytes(text)[a];
                count++;
            }
            string memory find = string(findBytes);
            if (
                keccak256(abi.encodePacked(find)) ==
                keccak256(abi.encodePacked(search))
            ) {
                exist = true;
                break;
            }
        }
        return exist;
    }

    /*
     * @dev Replaces the first occurance of a string in the text with a new string.
     * @param text The string to check.
     * @param replace The string to search for.
     * @param newtext The string to replace with.
     * @return A new string which contains the replaced text.
     */
    function replaceOne(
        string memory text,
        string memory replace,
        string memory newtext
    ) internal pure returns (string memory) {
        bytes memory nt = bytes(text);
        bytes memory nc = bytes(replace);
        bytes memory nrt = bytes(newtext);
        string memory replacedString = "";
        for (uint256 i = 0; i < nt.length; i++) {
            bytes memory findBytes = new bytes(nc.length);
            uint256 count = 0;
            for (uint256 a = i; a < (i + nc.length); a++) {
                findBytes[count] = bytes(text)[a];
                count++;
            }
            string memory find = string(findBytes);
            if (
                keccak256(abi.encodePacked(find)) ==
                keccak256(abi.encodePacked(replace))
            ) {
                bytes memory findBytes1 = new bytes(
                    (nt.length - nc.length) + nrt.length
                );
                uint256 count1 = 0;
                for (uint256 a = 0; a < i; a++) {
                    findBytes1[count1] = bytes(text)[a];
                    count1++;
                }
                for (uint256 a = 0; a < nrt.length; a++) {
                    findBytes1[count1] = bytes(newtext)[a];
                    count1++;
                }
                for (uint256 a = (i + nc.length); a < (nt.length); a++) {
                    findBytes1[count1] = bytes(text)[a];
                    count1++;
                }
                replacedString = string(findBytes1);
                break;
            }
        }
        return replacedString;
    }

    /*
     * @dev Replaces all occurance of a string in the text with a new string.
     * @param text The string to check.
     * @param replace The string to search for.
     * @param newtext The string to replace with.
     * @return A new string which contains the replaced text.
     */
    function replaceAll(
        string memory text,
        string memory replace,
        string memory newtext
    ) internal pure returns (string memory) {
        bytes memory nt = bytes(text);
        bytes memory nc = bytes(replace);
        bytes memory nrt = bytes(newtext);
        string memory replacedString = "";
        uint256 i = 0;
        uint256 pointA = 0;
        while (i < nt.length) {
            bytes memory findBytes = new bytes(nc.length);
            uint256 count = 0;
            for (
                uint256 a = i;
                a <
                (
                    (nc.length > (nt.length - i))
                        ? (nt.length - i)
                        : (i + nc.length)
                );
                a++
            ) {
                findBytes[count] = bytes(text)[a];
                count++;
            }
            string memory find = string(findBytes);
            if (
                keccak256(abi.encodePacked(find)) ==
                keccak256(abi.encodePacked(replace))
            ) {
                bytes memory findBytes1 = new bytes((i - pointA) + nrt.length);
                uint256 count1 = 0;
                for (uint256 a = pointA; a < i; a++) {
                    findBytes1[count1] = bytes(text)[a];
                    count1++;
                }
                for (uint256 a = 0; a < nrt.length; a++) {
                    findBytes1[count1] = bytes(newtext)[a];
                    count1++;
                }
                replacedString = string.concat(
                    replacedString,
                    string(findBytes1)
                );
                i += nc.length;
                pointA = i;
            } else {
                i += 1;
            }
        }
        bytes memory findBytes2 = new bytes(nt.length - pointA);
        uint256 count2 = 0;
        for (uint256 a = pointA; a < nt.length; a++) {
            findBytes2[count2] = bytes(text)[a];
            count2++;
        }
        replacedString = string.concat(replacedString, string(findBytes2));
        return replacedString;
    }

    /*
     * @dev Matches a string with the text.
     * @param text The string to check.
     * @param matchtext The string to match with.
     * @return A bool and an int256 if the string was found and the index it was found at.
     */
    function matchStr(
        string memory text,
        string memory matchtext
    ) internal pure returns (bool exist, int256 start) {
        bytes memory nt = bytes(text);
        bytes memory nc = bytes(matchtext);
        bool matchExist = false;
        int256 matchStart = -1;
        int256 count1 = 0;
        for (uint256 i = 0; i < nt.length; i++) {
            bytes memory findBytes = new bytes(nc.length);
            uint256 count = 0;
            for (uint256 a = i; a < (i + nc.length); a++) {
                findBytes[count] = bytes(text)[a];
                count++;
            }
            string memory find = string(findBytes);
            if (
                keccak256(abi.encodePacked(find)) ==
                keccak256(abi.encodePacked(matchtext))
            ) {
                matchExist = true;
                matchStart = count1;
                break;
            }
            count1++;
        }
        return (matchExist, matchStart);
    }

    /*
     * @dev Changes string to lowercase.
     * @param text The string to change.
     * @return A new string which is all lowercase.
     */
    function toLowerCase(
        string memory text
    ) internal pure returns (string memory) {
        string
            memory charsString = "Aa;Bb;Cc;Dd;Ee;Ff;Gg;Hh;Ii;Jj;Kk;Ll;Mm;Nn;Oo;Pp;Qq;Rr;Ss;Tt;Uu;Vv;Ww;Xx;Yy;Zz";
        string[] memory chars = split(charsString, ";", 40);
        bytes memory nt = bytes(text);
        string memory lowerCase = "";
        for (uint256 i = 0; i < nt.length; i++) {
            bytes memory findBytes = new bytes(1);
            findBytes[0] = bytes(text)[i];
            bool exist = false;
            for (uint256 a = 0; a < chars.length; a++) {
                bool contains = includes(chars[a], string(findBytes));
                if (contains) {
                    bytes memory findBytes1 = new bytes(1);
                    findBytes1[0] = bytes(chars[a])[1];
                    lowerCase = string.concat(lowerCase, string(findBytes1));
                    exist = true;
                    break;
                }
            }
            if (exist == false) {
                lowerCase = string.concat(lowerCase, string(findBytes));
            }
        }
        return lowerCase;
    }

    /*
     * @dev Converts string to uppercase.
     * @param text The string to change.
     * @return A new string which is all uppercase.
     */
    function toUpperCase(
        string memory text
    ) internal pure returns (string memory) {
        string
            memory charsString = "Aa;Bb;Cc;Dd;Ee;Ff;Gg;Hh;Ii;Jj;Kk;Ll;Mm;Nn;Oo;Pp;Qq;Rr;Ss;Tt;Uu;Vv;Ww;Xx;Yy;Zz";
        string[] memory chars = split(charsString, ";", 40);
        bytes memory nt = bytes(text);
        string memory upperCase = "";
        for (uint256 i = 0; i < nt.length; i++) {
            bytes memory findBytes = new bytes(1);
            findBytes[0] = bytes(text)[i];
            bool exist = false;
            for (uint256 a = 0; a < chars.length; a++) {
                bool contains = includes(chars[a], string(findBytes));
                if (contains) {
                    bytes memory findBytes1 = new bytes(1);
                    findBytes1[0] = bytes(chars[a])[0];
                    upperCase = string.concat(upperCase, string(findBytes1));
                    exist = true;
                    break;
                }
            }
            if (exist == false) {
                upperCase = string.concat(upperCase, string(findBytes));
            }
        }
        return upperCase;
    }

    /*
     * @dev Repeats a string as many times as repeatLength
     * @param text The string to repeat.
     * @param repeatLength The amount of times to repeat.
     * @return A new string which is which contains all repetations of the text
     */
    function repeat(
        string memory text,
        uint256 repeatLength
    ) internal pure returns (string memory) {
        string memory repeatedString = "";
        for (uint256 i = 0; i < repeatLength; i++) {
            repeatedString = string.concat(repeatedString, text);
        }
        return repeatedString;
    }

    /*
     * @dev Adds padding to the start of the string.
     * @param text The string to pad.
     * @param lengthCount The length needed for the string
     * @param padding The padding to string.
     * @return A new string which is padded at the start.
     */
    function padStart(
        string memory text,
        uint256 lengthCount,
        string memory padding
    ) internal pure returns (string memory) {
        string memory paddedString = "";
        bytes memory nt = bytes(text);
        for (
            uint256 i = 0;
            i <
            ((lengthCount > nt.length ? lengthCount : nt.length) - nt.length);
            i++
        ) {
            paddedString = string.concat(paddedString, padding);
        }
        return string.concat(paddedString, text);
    }

    /*
     * @dev Adds padding to the end of the string.
     * @param text The string to pad.
     * @param lengthCount The length needed for the string
     * @param padding The padding to string.
     * @return A new string which is padded at the end.
     */
    function padEnd(
        string memory text,
        uint256 lengthCount,
        string memory padding
    ) internal pure returns (string memory) {
        string memory paddedString = "";
        bytes memory nt = bytes(text);

        for (
            uint256 i = 0;
            i <
            ((lengthCount > nt.length ? lengthCount : nt.length) - nt.length);
            i++
        ) {
            paddedString = string.concat(paddedString, padding);
        }
        return string.concat(text, paddedString);
    }

    /*
     * Slice a section of string out of the string.
     * @param text The string to slice.
     * @param start The index to start slice
     * @param end The index to end slice.
     * @return A new string that does not contain from the @param start to the @param end.
     */
    function slice(
        string memory text,
        uint256 start,
        uint256 end
    ) internal pure returns (string memory) {
        bytes memory nt = bytes(text);
        bytes memory findBytes = new bytes(nt.length - ((end - 1) + start));
        uint256 count = 0;
        for (uint256 a = 0; a < start; a++) {
            findBytes[count] = bytes(text)[a];
            count++;
        }
        for (uint256 a = end + 1; a < nt.length; a++) {
            findBytes[count] = bytes(text)[a];
            count++;
        }
        string memory sliceString = string(findBytes);
        return sliceString;
    }

    /*
     * Checks if the text is equal to a string
     * @param text The string to check.
     * @param compare The string to check with
     * @return A bool which is true if the text is equal
     */
    function isEqual(
        string memory text,
        string memory compare
    ) internal pure returns (bool) {
        return (keccak256(abi.encodePacked(text)) ==
            keccak256(abi.encodePacked(compare)));
    }

    /*
     * Checks if the text is equal to a string in both upper and lowercase
     * @param text The string to check.
     * @param compare The string to check with
     * @return A bool which is true if the text is equal
     */
    function isEqualCase(
        string memory text,
        string memory compare
    ) internal pure returns (bool) {
        return ((keccak256(abi.encodePacked(toUpperCase(text))) ==
            keccak256(abi.encodePacked(toUpperCase(compare)))) &&
            (keccak256(abi.encodePacked(toLowerCase(text))) ==
                keccak256(abi.encodePacked(toLowerCase(compare)))));
    }

    /*
     * Creates a substring from the text.
     * @param text The string to create the string from.
     * @param start The index to start the sub string
     * @param end The index to end the sub string.
     * @return A new string that is a sub string of the text from the @param start to the @param end.
     */
    function substring(
        string memory text,
        uint256 start,
        uint256 end
    ) internal pure returns (string memory) {
        bytes memory findBytes = new bytes((end + 1) - start);
        uint256 count = 0;
        for (uint256 a = start; a < (end + 1); a++) {
            findBytes[count] = bytes(text)[a];
            count++;
        }
        string memory subString = string(findBytes);
        return subString;
    }

    /*
     * @dev Removes unnecesary space from the start of the string.
     * @param text The string to trim.
     * @return A new string which is trimmed at the start.
     */
    function trimStart(
        string memory text
    ) internal pure returns (string memory) {
        bytes memory nt = bytes(text);
        uint256 i = 0;
        uint256 count = 0;
        while (i < nt.length) {
            bytes memory findBytes = new bytes(1);
            findBytes[0] = bytes(text)[i];
            if (!isEqual(string(findBytes), " ")) {
                count = i;
                break;
            }
            i++;
        }
        string memory trimmedString = substring(text, count, nt.length - 1);
        return trimmedString;
    }

    /*
     * @dev Removes unnecesary space from the end of the string.
     * @param text The string to trim.
     * @return A new string which is trimmed at the end.
     */
    function trimEnd(string memory text) internal pure returns (string memory) {
        bytes memory nt = bytes(text);
        uint256 i = nt.length - 1;
        uint256 count = 0;
        while (i >= 0) {
            bytes memory findBytes = new bytes(1);
            findBytes[0] = bytes(text)[i];
            if (!isEqual(string(findBytes), " ")) {
                count = i;
                break;
            }
            i--;
        }
        string memory trimmedString = substring(text, 0, count);
        return trimmedString;
    }

    /*
     * @dev Removes unnecesary space from the start and end of the string.
     * @param text The string to trim.
     * @return A new string which is trimmed at the start and end.
     */
    function trim(string memory text) internal pure returns (string memory) {
        string memory startTrim = trimStart(text);
        string memory trimmedString = trimEnd(startTrim);
        return trimmedString;
    }

    /*
     * @dev Gets the character at an index in the text.
     * @param text The string to search.
     * @param index The index to get.
     * @return the character at the index.
     */
    function charAt(
        string memory text,
        uint256 index
    ) internal pure returns (string memory) {
        bytes memory findBytes = new bytes(1);
        findBytes[0] = bytes(text)[index];
        return string(findBytes);
    }

    /*
     * @dev Gets the first index of a character in the text.
     * @param text The string to search.
     * @param char The character to get.
     * @return the index of the character.
     */
    function indexOf(
        string memory text,
        string memory char
    ) internal pure returns (uint256) {
        bytes memory nt = bytes(text);
        uint256 count = 0;
        for (uint256 i = 0; i < nt.length; i++) {
            bytes memory findBytes = new bytes(1);
            findBytes[0] = bytes(text)[i];
            if (isEqual(string(findBytes), char)) {
                count = i;
                break;
            }
        }
        return count;
    }

    /*
     * @dev Gets the last index of a character in the text.
     * @param text The string to search.
     * @param char The character to get.
     * @return the index of the character.
     */
    function lastIndexOf(
        string memory text,
        string memory char
    ) internal pure returns (uint256) {
        bytes memory nt = bytes(text);
        uint256 count = 0;
        for (uint256 i = 0; i < nt.length; i++) {
            bytes memory findBytes = new bytes(1);
            findBytes[0] = bytes(text)[i];
            if (isEqual(string(findBytes), char)) {
                count = i;
            }
        }
        return count;
    }

    /*
     * @dev Gets all the index of a character in the text.
     * @param text The string to search.
     * @param char The character to get.
     * @return the index of the character.
     */
    function allIndexOf(
        string memory text,
        string memory char,
        uint256 proposedLength
    ) internal pure returns (uint256[] memory) {
        bytes memory nt = bytes(text);
        uint256[] memory array = new uint256[](proposedLength);
        uint256 visiblePoint = 0;
        for (uint256 i = 0; i < nt.length; i++) {
            bytes memory findBytes = new bytes(1);
            findBytes[0] = bytes(text)[i];
            if (isEqual(string(findBytes), char)) {
                array[visiblePoint] = i;
                visiblePoint++;
            }
        }
        uint256[] memory n_array = new uint256[](visiblePoint + 1);

        for (uint256 a = 0; a < (visiblePoint + 1); a++) {
            n_array[a] = array[a];
        }
        array = new uint256[](0);
        return n_array.length > 1 ? n_array : new uint256[](0);
    }

    /*
     * @dev Checks if the text starts with a string.
     * @param text The string to search.
     * @param start The string to check for.
     * @return A bool if the text starts with a string.
     */
    function startsWith(
        string memory text,
        string memory start
    ) internal pure returns (bool) {
        bytes memory nt = bytes(text);
        bytes memory nc = bytes(start);
        bool startsWidthString = false;
        if (nt.length > nc.length) {
            bytes memory findBytes = new bytes(nc.length);
            uint256 count = 0;
            for (uint256 a = 0; a < nc.length; a++) {
                findBytes[count] = bytes(text)[a];
                count++;
            }
            string memory find = string(findBytes);
            startsWidthString = isEqual(start, find);
        }
        return startsWidthString;
    }

    /*
     * @dev Checks if the text ends with a string.
     * @param text The string to search.
     * @param end The string to check for.
     * @return A bool if the text ends with a string.
     */
    function endsWith(
        string memory text,
        string memory end
    ) internal pure returns (bool) {
        bytes memory nt = bytes(text);
        bytes memory nc = bytes(end);
        bool endsWidthString = false;
        if (nt.length > nc.length) {
            bytes memory findBytes = new bytes(nc.length);
            uint256 count = 0;
            for (uint256 a = (nt.length - nc.length); a < nt.length; a++) {
                findBytes[count] = bytes(text)[a];
                count++;
            }
            string memory find = string(findBytes);
            endsWidthString = isEqual(end, find);
        }
        return endsWidthString;
    }

    /*
     * @dev Parses a string to the uint256 of the string.
     * @param text The string to parse.
     * @return The uint256 of the string.
     */
    function parseInt(string memory text) internal pure returns (uint256) {
        uint256 number = 0;
        bytes memory nt = bytes(text);
        uint256[] memory numbers = new uint256[](10);
        numbers[0] = 0;
        numbers[1] = 1;
        numbers[2] = 2;
        numbers[3] = 3;
        numbers[4] = 4;
        numbers[5] = 5;
        numbers[6] = 6;
        numbers[7] = 7;
        numbers[8] = 8;
        numbers[9] = 9;

        string[] memory numbersString = new string[](10);
        numbersString[0] = "0";
        numbersString[1] = "1";
        numbersString[2] = "2";
        numbersString[3] = "3";
        numbersString[4] = "4";
        numbersString[5] = "5";
        numbersString[6] = "6";
        numbersString[7] = "7";
        numbersString[8] = "8";
        numbersString[9] = "9";

        for (uint256 i = 0; i < nt.length; i++) {
            bytes memory findBytes = new bytes(1);
            findBytes[0] = bytes(text)[i];
            string memory numberStringToCheck = string(findBytes);
            uint256 checkNum = 0;
            for (uint256 a = 0; a < numbersString.length; a++) {
                if (isEqual(numbersString[a], numberStringToCheck)) {
                    checkNum = a;
                    break;
                }
            }
            uint256 numberToParse = numbers[checkNum];
            string memory subString = substring(text, i, nt.length - 1);
            number += (numberToParse * (10 ** (bytes(subString).length - 1)));
        }
        return number;
    }

    function logBase10(uint256 number) private pure returns (uint256) {
        uint256 log = 0;
        while ((10 ** log) < number) {
            log++;
        }
        return log + 1;
    }

    /*
     * @dev Changes a uint256 to a string.
     * @param number The number to change.
     * @return The string.
     */
    function parseString(uint256 number) internal pure returns (string memory) {
        uint256 subNum = 1;
        if (number > 0) {
            if ((number / subNum) > 9) {
                subNum *= 10;
                while ((number / subNum) > 9) {
                    subNum *= 10;
                }
            } else if ((number / subNum) < 1) {
                subNum /= 10;
                while ((number / subNum) < 1) {
                    subNum /= 10;
                }
            }
        }
        string[] memory numbersString = new string[](10);
        numbersString[0] = "0";
        numbersString[1] = "1";
        numbersString[2] = "2";
        numbersString[3] = "3";
        numbersString[4] = "4";
        numbersString[5] = "5";
        numbersString[6] = "6";
        numbersString[7] = "7";
        numbersString[8] = "8";
        numbersString[9] = "9";
        string memory text = "";
        uint256 workingNumber = number;
        uint256 lengthOfNumber = logBase10(subNum);
        for (uint256 i = 0; i < lengthOfNumber; i++) {
            uint256 firstNumber = workingNumber / subNum;
            uint256 remainder = workingNumber % subNum;
            text = string.concat(text, numbersString[firstNumber]);
            workingNumber = remainder;
            subNum /= 10;
        }
        return text;
    }

    /*
     * Gets the length of the string.
     * @param text The string to ge length.
     * @return The uint256 length of the string.
     */
    function length(string memory text) internal pure returns (uint256) {
        bytes memory nt = bytes(text);
        return nt.length;
    }
}
