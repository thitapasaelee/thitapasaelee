import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.HashSet;
import java.util.Stack;

//=============================================================================
//   TODO   Finding Components
//   Finds all the strongly connected subgraphs in the graph
//   Labels each stop with the number of the subgraph it is in and
//   sets the subGraphCount of the graph to the number of subgraphs.
//   Uses Kosaraju's_algorithm   (see lecture slides, based on
//   https://en.wikipedia.org/wiki/Kosaraju%27s_algorithm)
//=============================================================================

public class Components{

    // Use Kosaraju's algorithm.
    // In the forward search, record which nodes are visited with a visited set.
    // In the backward search, use the setSubGraphId and getSubGraphID methods
    // on the stop to record the component (and whether the node has been visited
    // during the backward search).
    // Alternatively, during the backward pass, you could use a Map<Stop,Stop>
    // to record the "root" node of each component, following the original version
    // of Kosaraju's algorithm, but this is unnecessarily complex.

    
    public static void findComponents(Graph graph){ // find all  strongly connected components in directed graph 
        System.out.println("calling findComponents");
        graph.resetSubGraphIds();
        
        // Kosaraju's algorithm
        Stack<Stop> stack = new Stack<>();
        Set<Stop> visited = new HashSet<>();
        for (Stop stop : graph.getStops()){
            if (!visited.contains(stop)){ // DFS traversal on each unvisited stop
                visited.add(stop);
                forwardDFS(stop, visited, stack);
            }
        }
        visited.clear();
        int subgraphCount = 0;
        while (!stack.isEmpty()){
            Stop stop = stack.pop(); // take stops out from the stack
            if (!visited.contains(stop)){ // DFS on each stop in the stack
                // assign each stop a subgraph ID & increment subgraphCount for loop until empty
                visited.add(stop);
                backwardDFS(stop, visited, subgraphCount++);
            }
        }
        graph.setSubGraphCount(subgraphCount);
    }
    
    private static void forwardDFS(Stop stop, Set<Stop> visited, Stack<Stop> stack){
        // DFS on the forward edges of a given stop
        for (Edge edge : stop.getForwardEdges()){
            Stop neighbour = edge.toStop();
            if (!visited.contains(neighbour)){
                // adding each visited stop to the stack
                visited.add(neighbour);
                forwardDFS(neighbour, visited, stack);
            }
        }
        stack.push(stop); 
    }
    
    private static void backwardDFS(Stop stop, Set<Stop> visited, int subgraphCount){
        stop.setSubGraphId(subgraphCount); // set SubGraphId with subgraphCount
        // DFS on the backward edges of a given stop
        for (Edge edge : stop.getBackwardEdges()){
            Stop neighbour = edge.fromStop();
            if (!visited.contains(neighbour)){
                // assigning each visited stop a subgraph ID
                visited.add(neighbour);
                backwardDFS(neighbour, visited, subgraphCount);
            }
        }
    }
}



