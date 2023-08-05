
import java.util.*;

public class LempelZiv {
    /**
     * Take uncompressed input as a text string, compress it, and return it as a
     * text string.
     */
    public static String compress(String input) {
        // TODO fill this in.
        StringBuilder result = new StringBuilder();
        // String result = "";
        String current, previous;
        int windowSize = 100; // window size of 100 characters
        int cursor, i, j, index, offset, length, len, min, max;
        char character;
        boolean found;
        cursor = 0;
        while (cursor < input.length()) { // until end of input
            length = 0; // length of longest match
            index = -1; // index of longest match
            found = false; // found status start with not found
            // search for longest match within window
            max = Math.max(0, cursor - windowSize); // maximum length of 0 and cursor - windowSize
            for (i = max; i < cursor; i++) { // loop follow maximum length
                len = 0; // length of match character
                current = input.substring(cursor); // substring from cursor position
                previous = input.substring(i, cursor); // substring from i to cursor
                min = Math.min(current.length(), previous.length()); // find minimum length of current and previous substrings
                for (j = 0; j < min; j++) { // loop follow minimum length
                    if (current.charAt(j) != previous.charAt(j)) {  // when character of current and previous not match
                        break; // stop the loop
                    }
                    len++; // if match = count length of match character
                }
                if (len > length) { // when length of match character is longer than length of longest match
                    length = len; // update length
                    index = i; // update index
                    found = true; // update found status
                }
            }
            if (found) { // when found the match
                offset = cursor - index; // go back to repeated character(s)
                character = input.charAt(cursor + length); // length of the character(s)
                // result+="[" + offset + "|" + length + "|"+ character + "]"; 
                result.append("[").append(offset).append("|").append(length).append("|").append(character).append("]"); // [offset, length, next char]
                cursor += length + 1; // update cursor position to next position with length+1
            } else { // if not found
                character = input.charAt(cursor);
                // result+="[" + 0 + "|" + 0 + "|" + character + "]"; 
                result.append("[").append(0).append("|").append(0).append("|").append(character).append("]"); // just next character
                cursor++;
            }
        }
        // return result;
        return result.toString();
    }

    /**
     * Take compressed input as a text string, decompress it, and return it as a
     * text string.
     */
    public static String decompress(String compressed) {
        // TODO fill this in.
        // String result = "";
        StringBuilder result = new StringBuilder();
        int cursor, start, end, offset, length;
        char character;
        cursor = 0;
        //[offset | length | next char]
        while (cursor < compressed.length()) {
            start = cursor + 1; // start is get index after skip character '['
            end = compressed.indexOf("|", start); // end is get index of next '|'
            offset = Integer.parseInt(compressed.substring(start, end)); // offset is between '[' and '|'
            
            start = end + 1; // start is get index after skip '|'
            end = compressed.indexOf("|", start); // end is get index of next '|'
            length = Integer.parseInt(compressed.substring(start, end)); // length is between '|' and '|'
            
            start = end + 1; // start is get index after skip '|'
            end = compressed.indexOf("]", start); // end is get index of next ']'
            character = compressed.charAt(end - 1); // character is between '|' and ']'
            
            for (int j = 0; j < length; j++) { // loop follow length
                // result += result.charAt(result.length() - offset);  
                result.append(result.charAt(result.length() - offset));// append each character at position length of result - offset
            }
            // result+=character; 
            result.append(character); // append character
            cursor = end + 1; // update cursor to last end + 1
        }
        // return result;
        return result.toString();
    }

    /**
     * The getInformation method is here for your convenience, you don't need to
     * fill it in if you don't want to. It is called on every run and its return
     * value is displayed on-screen. You can use this to print out any relevant
     * information from your compression.
     */
    public String getInformation() {
        return "";
    }
}
