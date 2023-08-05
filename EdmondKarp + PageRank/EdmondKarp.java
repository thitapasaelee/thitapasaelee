
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.Queue;
import java.util.HashMap;
import java.util.ArrayDeque;
import java.util.Collection;
import java.util.Map;
import javafx.util.Pair;

/** Edmond karp algorithm to find augmentation paths and network flow.
 * 
 * This would include building the supporting data structures:
 * 
 * a) Building the residual graph(that includes original and backward (reverse) edges.)
 *     - maintain a map of Edges where for every edge in the original graph we add a reverse edge in the residual graph.
 *     - The map of edges are set to include original edges at even indices and reverse edges at odd indices (this helps accessing the corresponding backward edge easily)
 *     
 *     
 * b) Using this residual graph, for each city maintain a list of edges out of the city (this helps accessing the neighbours of a node (both original and reverse))

 * The class finds : augmentation paths, their corresponing flows and the total flow
 * 
 * 
 */

public class EdmondKarp {
    // class members

    //data structure to maintain a list of forward and reverse edges - forward edges stored at even indices and reverse edges stored at odd indices
    private static Map<String,Edge> edges; 

    // Augmentation path and the corresponding flow
    private static ArrayList<Pair<ArrayList<String>, Integer>> augmentationPaths =null;

    
    //TODO:Build the residual graph that includes original and reverse edges 
    public static void computeResidualGraph(Graph graph){
        // TODO
        edges = new HashMap<>();
        int id = 0;

        for(Edge edge : graph.getOriginalEdges()){
            Edge forwardEdge = new Edge(edge.fromCity(), edge.toCity(), edge.transpType(), edge.capacity(), edge.flow());
            Edge reverseEdge = new Edge(edge.toCity(), edge.fromCity(), edge.transpType(), 0, edge.flow()); 

            edges.put(Integer.toString(id), forwardEdge); // id is even
            edges.put(Integer.toString(id+1), reverseEdge); // id is odd
            
            // update the edges
            graph.getCity(forwardEdge.fromCity().getId()).addEdgeId(Integer.toString(id));
            graph.getCity(reverseEdge.fromCity().getId()).addEdgeId(Integer.toString(id+1));

            id += 2;
        }

        printResidualGraphData(graph);  //may help in debugging
        // END TODO
    }

    // Method to print Residual Graph 
    public static void printResidualGraphData(Graph graph){
        System.out.println("\nResidual Graph");
        System.out.println("\n=============================\nCities:");
        for (City city : graph.getCities().values()){
            System.out.print(city.toString());

            // for each city display the out edges 
            for(String eId: city.getEdgeIds()){
                System.out.print("["+eId+"] ");
            }
            System.out.println();
        }
        System.out.println("\n=============================\nEdges(Original(with even Id) and Reverse(with odd Id):");
        edges.forEach((eId, edge)->
                System.out.println("["+eId+"] " +edge.toString()));

        System.out.println("===============");
    }

    //=============================================================================
    //  Methods to access data from the graph. 
    //=============================================================================
    /**
     * Return the corresonding edge for a given key
     */

    public static Edge getEdge(String id){
        return edges.get(id);
    }

    /** find maximum flow
     * 
     */
    // TODO: Find augmentation paths and their corresponding flows
    public static ArrayList<Pair<ArrayList<String>, Integer>> calcMaxflows(Graph graph, City from, City to) {
        //TODO
        augmentationPaths = new ArrayList<>();
        EdmondKarp.computeResidualGraph(graph);
        while (true){
            Pair<ArrayList<String>, Integer> result = bfs(graph, from, to); // pair of augmpath and bottleneckflow
            ArrayList<String> path = result.getKey(); // store augmentation path
            Integer bottleneck = result.getValue(); // store bottleneck flow

            if (path == null){ // no path/visited all the path in the graph
                break; // go out of loop
            }
            
            // if have path, add augmentation path in
            augmentationPaths.add(new Pair<>(path, bottleneck)); 
            
            // update the capacity of edges
            for (String edgeId : path){
                // for even id edge - forward edge
                Edge edge = getEdge(edgeId);
                edge.setCapacity(edge.capacity() - bottleneck);
                
                // for odd id edge - reverse edge
                Edge reverseEdge = getEdge(Integer.toString(Integer.parseInt(edgeId) % 2 == 0 ? Integer.parseInt(edgeId) + 1 
                : Integer.parseInt(edgeId) - 1)); // mod 2 - if id is even(eg.2) then revese edge + 1(3rd reverse edge), if id is odd the -1 then reverse edge - 1
                reverseEdge.setCapacity(reverseEdge.capacity() + bottleneck);
            }
        }

        
        // END TODO
        return augmentationPaths;
    }

    // TODO:Use BFS to find a path from s to t along with the correponding bottleneck flow
    public static Pair<ArrayList<String>, Integer>  bfs(Graph graph, City s, City t) {

        ArrayList<String> augmentationPath = new ArrayList<String>(); // path from s to t
        HashMap<String, String> backPointer = new HashMap<String, String>(); // store what it goes through which cities and which edges
        // TODO
        HashSet<String> visited = new HashSet<>(); // store cites that bfs has visited
        Queue<City> queue = new LinkedList<>(); // queue to the next city
        queue.offer(s); // first city is s
        visited.add(s.getId()); // a has been visited
        while (!queue.isEmpty()){ // if queue is not empty
            City city = queue.poll(); // throw the first city in the queue out

            for (String edgeId : city.getEdgeIds()){
                Edge edge = getEdge(edgeId);
                
                // if edge hasn't visited
                if (!visited.contains(edge.toCity().getId()) && edge.capacity() > 0){
                    visited.add(edge.toCity().getId()); // city has visited
                    queue.offer(graph.getCity(edge.toCity().getId())); // put into queue
                    backPointer.put(edge.toCity().getId(), edgeId); // store backpointer where we came from
                    
                    // if city that the edge is about to go = to the city t
                    if (edge.toCity().getId().equals(t.getId())){
                        String currentCity = t.getId(); // get city id
                        int bottleneckFlow = Integer.MAX_VALUE; // initiate bottleneckflow
                        
                        // loop until the backpointer go back to the s city (source city)
                        while (!currentCity.equals(s.getId())){
                            String currentEdgeId = backPointer.get(currentCity); // current city of backpointer
                            Edge currentEdge = getEdge(currentEdgeId); // edge from the current edge id

                            augmentationPath.add(0, currentEdgeId); // index 0
                            bottleneckFlow = Math.min(bottleneckFlow, currentEdge.capacity()); // get the min of those 2 parameters until the loop ends

                            currentCity = currentEdge.fromCity().getId();
                        }
                        return new Pair<>(augmentationPath, bottleneckFlow);
                    }
                }
            }
        }
        // END TODO
        return new Pair(null,0); // if queue is 0 return null
    }
   
}


