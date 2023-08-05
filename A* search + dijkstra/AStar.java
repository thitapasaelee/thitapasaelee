/**
 * Implements the A* search algorithm to find the shortest path
 * in a graph between a start node and a goal node.
 * It returns a Path consisting of a list of Edges that will
 * connect the start node to the goal node.
 */

import java.util.Collections;
import java.util.Collection;
import java.util.Set;
import java.util.HashSet;
import java.util.Map;
import java.util.HashMap;

import java.util.List;
import java.util.ArrayList;
import java.util.PriorityQueue;

public class AStar {

    private static String timeOrDistance = "distance";    // way of calculating cost: "time" or "distance"


    // find the shortest path between two stops
    public static List<Edge> findShortestPath(Stop start, Stop goal, String timeOrDistance){
        if (start == null || goal == null) {return null;}
        timeOrDistance= (timeOrDistance.equals("time"))?"time":"distance";

        // A* - find the shortest path in a graph between a start node to a goal node
        AStar.timeOrDistance = timeOrDistance; // set to time/distance
        Map<Stop, Edge> backpointers = new HashMap<Stop, Edge>(); // map - store previous stops
        Set<Stop> visited = new HashSet<Stop>(); // set - keep track of visited stops
        PriorityQueue<PathItem> queue = new PriorityQueue<PathItem>(); // priority queue - keep track of stops to visit next
        PathItem startItem = new PathItem(start, null, 0, heuristic(start, goal)); // create a PathItem for the start stop
        queue.offer(startItem); // add it to the queue
        while (!queue.isEmpty()){ // continue until there are no more stops in the queue
            PathItem current = queue.poll(); // get the stop with the lowest cost so far
            Stop currentStop = current.getStop(); // get current stop
            if (visited.contains(currentStop)){ //  check if the current stop has been visited or not
                continue;
            }
            visited.add(currentStop); // mark the current stop that has been visited
            backpointers.put(currentStop, current.getEdge()); // add the current stop to backpointers map
            if (currentStop.equals(goal)){ // if reached the goal stop
                return buildPath(start, goal, backpointers); // return the shortest path from start to the goal
            }
            Collection<Edge> edges = new HashSet<Edge>(); // get all edges for the current stop
            edges.addAll(currentStop.getForwardEdges());
            edges.addAll(currentStop.getBackwardEdges());
            for (Edge edge : edges){ // for each edge
                Stop nextStop = edge.toStop(); // get the next stop
                if (!visited.contains(nextStop)){ // if next stop hasn't been visited
                    double newCost = current.getCost() + edgeCost(edge); // calculate the new cost to get to next stop
                    double estimatedTotalCost = newCost + heuristic(nextStop, goal); // estimate the total cost: from the start stop -> goal stop
                    PathItem nextItem = new PathItem(nextStop, edge, newCost, estimatedTotalCost); // create new PathItem for the next stop
                    queue.offer(nextItem); // add the next stop to the priority queue
                }
            }
        }
        return null; 
    }

    private static List<Edge> buildPath(Stop start, Stop goal, Map<Stop, Edge> backpointers) {
        List<Edge> path = new ArrayList<Edge>(); // create empty list
        Stop current = goal;
        while (!current.equals(start)){ // iterate through the backpointers until current stop = the start stop
            Edge edge = backpointers.get(current);
            if (edge == null) { // no edge
                return null;
            }
            path.add(edge); // add edge to path
            current = edge.fromStop(); // set the current stop to be the stop that the edge came from
        }
        Collections.reverse(path); // reverse path coz it was constructed backwards
        return path;
    }




    /** Return the heuristic estimate of the cost to get from a stop to the goal */
    public static double heuristic(Stop current, Stop goal) {
        if (timeOrDistance.equals("distance")){ return current.distanceTo(goal);}
        else if (timeOrDistance=="time"){return current.distanceTo(goal) / Transport.TRAIN_SPEED_MPS;}
        else {return 0;}
    }

    /** Return the cost of traversing an edge in the graph */
    public static double edgeCost(Edge edge){
        if (timeOrDistance.equals("distance")){ return edge.distance();}
        else if (timeOrDistance=="time"){return edge.time();}
        else {return 1;}
    }


}
