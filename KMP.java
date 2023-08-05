/**
 * A new KMP instance is created for every substring search performed. Both the
 * pattern and the text are passed to the constructor and the search method. You
 * could, for example, use the constructor to create the match table and the
 * search method to perform the search itself.
 */
public class KMP {

    /**
     * Perform KMP substring search on the given text with the given pattern.
     * 
     * This should return the starting index of the first substring match if it
     * exists, or -1 if it doesn't.
     */
    public static int search(String pattern, String text) {
        // TODO fill this in.

        int[] lps = new int[pattern.length()]; // array lps is followed the length of pattern
        int i = 0; // prefix index
        int j = 0; // suffix index
        // loop until end length of pattern
        while(j<pattern.length()){
            // when match
            if(pattern.charAt(i) == pattern.charAt(j)){
                lps[j] = i + 1; // lps at suffix index = prefix index + 1
                i++; // next prefix index
                j++; // next suffix index
            } else { // when not match
                if(i!=0){ // when prefix index is not 0
                    i = lps[i-1]; // prefix index = lps at previous prefix index
                } else { // when prefix index is 0
                    lps[j] = 0; // lps at suffix index = 0
                    j++; // next suffix index
                }
            }
        }
        
        i = 0; // text index
        j = 0; // pattern index
        // loop until end length of text
        while(i<text.length()){
            // when match
            if(text.charAt(i)==pattern.charAt(j)){
                if(j==(pattern.length()-1)) { // when end of the pattern
                    return i-pattern.length() + 1; //return starting index of match
                }
                j++; // next text index
                i++; // next pattern index
            } else { // when not match
                if(j != 0){ // when pattern index is not 0
                    j = lps[j-1]; // pattern index = lps at previous pattern index
                } else { // when pattern index is 0
                    i++; // next pattern index
                }
            }
        }
        return -1; // no match
    }
}
