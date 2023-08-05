/**
 * A new instance of HuffmanCoding is created for every run. The constructor is
 * passed the full text to be encoded or decoded, so this is a good place to
 * construct the tree. You should store this tree in a field and then use it in
 * the encode and decode methods.
 */

import java.util.*;
class Node { // Node class
    char character;
    int frequency;
    Node left;
    Node right;
    Node(char character, int frequency) { // constructor
        this.character = character;
        this.frequency = frequency;
        this.left = null;
        this.right = null;
    }
}

public class HuffmanCoding {
    /**
     * This would be a good place to compute and store the tree.
     */
    private Node root;
    private Map<Character, String> codeTable;
    public HuffmanCoding(String text) {
        // TODO fill this in.
        Map<Character, Integer> frequencyTable = new HashMap<>();  // character frequencies table
        for (char ch : text.toCharArray()) { // each char in text and pull each char out
            frequencyTable.put(ch, frequencyTable.getOrDefault(ch, 0) + 1); // when see repeated char
        }
        // use frequency table to build Huffman tree
        PriorityQueue<Node> pq = new PriorityQueue<>((x, y) -> {
            if (x.frequency == y.frequency) {  // when two nodes have the same frequency
                return Character.compare(x.character, y.character); // compare characters for pick first nodes with smallest characters alphabetically
            }
            return x.frequency - y.frequency; // sort nodes based on frequencies
        });
        // create leaf node for each character and add it to priority queue
        for (Map.Entry<Character, Integer> entry : frequencyTable.entrySet()) {
            Node leaf = new Node(entry.getKey(), entry.getValue()); 
            pq.offer(leaf); // put in priority q
        }
        // combining nodes until left only root node
        while (pq.size() > 1) {
            Node left = pq.poll(); // lowest frequency
            Node right = pq.poll(); // second lowest frequency
            Node parent = new Node('\0', left.frequency + right.frequency); // create parent node with combined frequency
            parent.left = left; // set left
            parent.right = right; // set right
            pq.offer(parent); // add to priority queue
        }
        root = pq.poll(); // set root of Huffman tree (last remaining node in the priority queue)
        codeTable = new HashMap<>(); // binary codes for each character
    }

    /**
     * Take an input string, text, and encode it with the stored tree. Should
     * return the encoded text as a binary string, that is, a string containing
     * only 1 and 0.
     */
    public String encode(String text) {
        // TODO fill this in.
        //String result = "";
        StringBuilder result = new StringBuilder();
        generateCodes(root, "", codeTable); // generate binary codes for each character start from root
        for (char ch : text.toCharArray()) {
            // result += codeTable.get(ch);
            result.append(codeTable.get(ch)); // append binary code each character to result
        }
        // return result;
        return result.toString();
    }

    /**
     * Take encoded input as a binary string, decode it using the stored tree,
     * and return the decoded text as a text string.
     */
    public String decode(String encoded) {
        // TODO fill this in.
        StringBuilder result = new StringBuilder();
        // String result = "";
        Node current = root; // start decoding from root node
        for (char bit : encoded.toCharArray()) {
            if (bit == '0') { // when bit is 0
                current = current.left; // move to left child node
            } else if (bit == '1') { // when bit is 1
                current = current.right; // move to right child node
            }
            if (current.left == null && current.right == null) { // when current node is leaf node
                // result += current.character; 
                result.append(current.character); // append character to result
                current = root; // move to root node
            }
        }
        // return result; 
        return result.toString();
    }

    /**
     * The getInformation method is here for your convenience, you don't need to
     * fill it in if you don't wan to. It is called on every run and its return
     * value is displayed on-screen. You could use this, for example, to print
     * out the encoding tree.
     */
    public String getInformation() {
        return "";
    }
    // generate binary codes for each character in the Huffman tree
    private void generateCodes(Node node, String code, Map<Character, String> codeTable) {
        if(node == null) { // current node not null
            return;
        }
        if(node.left == null && node.right == null) { // when node is leaf node
            codeTable.put(node.character, code); // add character and code to code table
        }
        generateCodes(node.left, code + "0", codeTable); // append 0 to current code for left child
        generateCodes(node.right, code + "1", codeTable); // append 1 to current code for right child
    }
}
