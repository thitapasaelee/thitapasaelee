import java.io.File;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.Set;
import java.util.TreeSet;
import java.util.HashSet;
import java.util.TreeMap;

/**
 * Graph is the data structure that stores the collection of stops, lines and connections. 
 * The Graph constructor is passed a Map of the stops, indexed by stopId and
 *  a Map of the Lines, indexed by lineId.
 * The Stops in the map have their id, name and GIS location.
 * The Lines in the map have their id, and lists of the stopIDs an times (in order)
 *
 * To build the actual graph structure, it is necessary to
 *  build the list of Edges out of each stop and the list of Edges into each stop
 * Each pair of adjacent stops in a Line is an edge.
 * We also need to create walking edges between every pair of stops in the whole
 *  network that are closer than walkingDistance.
 */
public class Graph {

    private Collection<Stop> stops;
    private Collection<Line> lines;
    private Collection<Edge> edges = new HashSet<Edge>();      // edges between Stops

    private int numComponents = 0;     // number of connected subgraphs (graph components)

    /**
     * Construct a new graph given a collection of stops and a collection of lines.
     */
    public Graph(Collection<Stop> stops, Collection<Line> lines) {
        this.stops = new TreeSet<Stop>(stops);
        this.lines = lines;

        // These are two of the key methods you must complete:
        createAndConnectEdges();
        computeNeighbours();

        // printGraphData();   // you could uncomment this to help in debugging your code
    }

    /** Print out the lines and stops in the graph to System.out */
    public void printGraphData(){
        System.out.println("============================\nLines:");
        for (Line line : lines){
            System.out.println(line.getId()+ "("+line.getStops().size()+" stops)");
        }
        System.out.println("\n=============================\nStops:");
        for (Stop stop : stops){
            System.out.println(stop+((stop.getSubGraphId()<0)?"":" subG:"+stop.getSubGraphId()));
            System.out.println("  "+stop.getForwardEdges().size()+" out edges; "+
                stop.getBackwardEdges().size() +" in edges; " +
                stop.getNeighbours().size() +" neighbours");
        }
        System.out.println("===============");
    }

    //============================================
    // Methods to build the graph structure. 
    //============================================

    /** 
     * From the loaded Line and Stop information,
     *  identify all the edges that connect stops along a Line.
     * - Construct the collection of all Edges in the graph  and
     * - Construct the forward and backward neighbour edges of each Stop.
     */
    private void createAndConnectEdges() {
        // TODO

        for (Line line : lines){ // for each Line in collection of Lines
            List<Stop> stopsOnLine = line.getStops();
            List<Integer> timesOnLine = line.getTimes();
            for (int i = 0; i < stopsOnLine.size() - 1; i++){ // lists of stops on line & iterates all pair of adjacent stops
                Stop fromStop = stopsOnLine.get(i);
                Stop toStop = stopsOnLine.get(i + 1);
                double distance = fromStop.distanceTo(toStop);
                double time = timesOnLine.get(i+1) - timesOnLine.get(i);
                Edge edge = new Edge(fromStop, toStop, line.getType(), line, time, distance); // create edge from each pair of adjacent stops
                edges.add(edge); // add the edge to the edges collection
                fromStop.addForwardEdge(edge); // add the edge to forwardEdges of the "fromStop"
                toStop.addBackwardEdge(edge);// add the edge to backwardEdges of the "toStop"
            }
        }
    }

    /** 
     * Construct the undirected graph of neighbours for each Stop:
     * For each Stop, construct a set of the stops that are its neighbours
     * from the forward and backward neighbour edges.
     * It may assume that there are no walking edges at this point.
     * 
     */
    public void computeNeighbours(){
        // TODO
        for (Stop stop : stops){ // each Stop collects its forward and backward neighbour edges
            Collection<Edge> forwardEdges = stop.getForwardEdges();
            Collection<Edge> backwardEdges = stop.getBackwardEdges();
            for (Edge edge : forwardEdges){ // for each edge 
                stop.addNeighbour(edge.toStop()); // adds neighbour toStop to the neighbour collection of stops
            }
            for (Edge edge : backwardEdges){ // for each edge 
                stop.addNeighbour(edge.fromStop()); // adds neighbour fromStop to the neighbour collection of stops
            }
        }
    }
    //=============================================================================
    //    Recompute Walking edges and add to the graph
    //=============================================================================
    //
    /** 
     * Reconstruct all the current walking edges in the graph,
     * based on the specified walkingDistance:
     * identify all pairs of stops * that are at most walkingDistance apart,
     * and construct edges (both ways) between the stops
     * add the edges to the forward and backward neighbouars of the Stops
     * add the edges to the walking edges of the graph.
     * Assume that all the previous walking edges have been removed
     */
    public void recomputeWalkingEdges(double walkingDistance) {
        int count = 0;
        // TODO
         for (Stop fromStop : stops){
            for (Stop toStop : stops){
                // stops have to be diff & the distance between them is within the specified walking distance
                if (fromStop != toStop && fromStop.distanceTo(toStop) <= walkingDistance){
                    double distance = fromStop.distanceTo(toStop); 
                    double time = distance/Transport.getSpeedMPS(Transport.WALKING); // calculate the time it takes to walk the distance
                    Edge edge = new Edge(fromStop, toStop, Transport.WALKING, null, time, fromStop.distanceTo(toStop));
                    edges.add(edge); // add the edge to the graph's edges
                    fromStop.addForwardEdge(edge); // add edge to the forward neighbours of fromStop
                    toStop.addBackwardEdge(edge); // add edge to the backward neighbours of toStop
                    count++; // increment the count of walking edges added
                }
            }
        }

        System.out.println("Number of walking edges added: " + count);
    }

    /** 
     * Remove all the current walking edges in the graph
     * - from the edges field (the collection of all the edges in the graph)
     * - from the forward and backward neighbours of each Stop.
     * - Resets the number of components back to 0 by
     *   calling  resetSubGraphIds()
     */
    public void removeWalkingEdges() {
        resetSubGraphIds();
        for (Stop stop : stops) {
            stop.deleteEdgesOfType(Transport.WALKING);// remove all edges of type walking
        }
        edges.removeIf((Edge e)->Transport.WALKING.equals(e.transpType()));

    }

    //=============================================================================
    //  Methods to access data from the graph. 
    //=============================================================================
    /**
     * Return a collection of all the stops in the network
     */        
    public Collection<Stop> getStops() {
        return Collections.unmodifiableCollection(stops);
    }

    /**
     * Return a collection of all the edges in the network
     */        
    public Collection<Edge> getEdges() {
        return Collections.unmodifiableCollection(edges);
    }

    /**
     * Return the first stop that starts with the specified prefix
     * (first by alphabetic order of name)
     */
    public Stop getFirstMatchingStop(String prefix) {
        for (Stop stop : stops) {
            if (stop.getName().startsWith(prefix)) {
                return stop;
            }
        }
        return null;
    }

    /** 
     * Return all the stops that start with the specified prefix
     * in alphabetic order.
     */
    public List<Stop> getAllMatchingStops(String prefix) {
        List<Stop> ans = new ArrayList<Stop>();
        for (Stop stop : stops) {
            if (stop.getName().startsWith(prefix)) {
                ans.add(stop);
            }
        }
        return ans;
    }

    public int getSubGraphCount() {
        return numComponents;
    }

    public void setSubGraphCount(int num) {
        numComponents = num;
        if (num==0){ resetSubGraphIds(); }
    }

    /**
     * reset the subgraph ID of all stops
     */
    public void resetSubGraphIds() {
        for (Stop stop : stops) {
            stop.setSubGraphId(-1);
        }
        numComponents = 0;
    }

}
