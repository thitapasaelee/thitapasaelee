import java.util.Collections;
import java.util.Collection;
import java.util.List;
import java.util.ArrayList;
import java.util.Set;
import java.util.HashSet;
import java.util.Map;
import java.util.HashMap;


//=============================================================================
//   TODO   Finding Articulation Points
//   Finds and returns a collection of all the articulation points in the undirected
//   graph, without walking edges
//=============================================================================

public class ArticulationPoints{

    // Use the algorithm from the lectures, but you will need a loop to check through
    // all the Stops in the graph to find any Stops which were not connected to the
    // previous Stops, and apply the lecture slide algorithm starting at each such stop.

    public static Collection<Stop> findArticulationPoints(Graph graph){
        System.out.println("calling findArticulationPoints");
        graph.computeNeighbours();   // To ensure that all stops have a set of (undirected) neighbour stops

        Set<Stop> articulationPoints = new HashSet<Stop>(); 
        
        
        Set<Stop> visited = new HashSet<>(); // set - to keep track of visited stops
        // maps - to keep track of the lowest(between current/neighbour) and num(order of num visited node) in DFS of each stop 
        Map<Stop, Integer> low = new HashMap<>();
        Map<Stop, Integer> num = new HashMap<>();
        int count = 0;
        for (Stop stop : graph.getStops()){ // loop through each stop in the graph
            if (!visited.contains(stop)){ // if has not been visited -> use findAPHelper method
                int rootChildren = 0;
                // start node: null -> no parent, stop (in the loop)
                findArticulationPointsHelper(graph, stop, null, visited, articulationPoints, low, num, count, rootChildren, stop); 
            }
        }
        return articulationPoints;
    }

    private static void findArticulationPointsHelper(Graph graph, Stop u, Stop parent, Set<Stop> visited, Set<Stop> articulationPoints, Map<Stop, Integer> low, Map<Stop, Integer> num, int count, int rootChildren, Stop root){
        visited.add(u); // add to visited
        low.put(u, count); // tmp variable for current node, u,and count
        num.put(u, count);
        count++;
        for (Stop v : u.getNeighbours()){ // loop the neighbours (v = each stop of u's neighbours)
            if (!visited.contains(v)){ // has not visited v (v is u's neighbours)
                if (u.equals(root)){ // if Stop u = Stop root
                    rootChildren++; // root has children node
                }
                // recursive call // v = current stop, u = parent stop
                findArticulationPointsHelper(graph, v, u, visited, articulationPoints, low, num, count, rootChildren, root);
                if (low.get(v) >= num.get(u) && parent != null){ // if count of v stop more/= count of u stops 
                    articulationPoints.add(u); //it is articulation point
                }
                low.put(u, Math.min(low.get(u), low.get(v))); // which stop (u/v) has lowest count of low? -> put value of u
            } else if (!v.equals(parent)){ // if visited, check if v not equal to parent
                low.put(u, Math.min(low.get(u), num.get(v))); // which stop (u/v) has lowest count of num? -> put value of u
            }
        }
        // when loop of u's neighbour is done
        if (u.equals(root) && rootChildren > 1){ // if stop u is root, children node is more than 1
            articulationPoints.add(u); // it is articulation point then add
        }
    } 
}








