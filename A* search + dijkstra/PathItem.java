/**
 * AStar search (and Dijkstra search) uses a priority queue of partial paths
 * that the search is building.
 * Each partial path needs several pieces of information, to specify
 * the path to that point, its cost so far, and its estimated total cost
 */

public class PathItem implements Comparable<PathItem>{

    // TODO
    
    // four fields
    private Stop stop;
    private Edge edge;
    private double cost;
    private double estimatedTotalCost;
    
    // constructor for the class
    public PathItem(Stop stop, Edge edge, double cost, double estimatedTotalCost){
        this.stop = stop;
        this.edge = edge;
        this.cost = cost;
        this.estimatedTotalCost = estimatedTotalCost;
    }
    
    // getter methods
    public Stop getStop(){
        return stop;
    }
    
    public Edge getEdge(){
        return edge;
    }
    
    public double getCost(){
        return cost;
    }
    
    public double getestimatedTotalCost(){
        return estimatedTotalCost;
    }
    
    @Override
    public int compareTo(PathItem other){
        if (this.estimatedTotalCost < other.estimatedTotalCost){ 
            return -1; // the cost of current object is LESS than the parameter object
        } else if (this.estimatedTotalCost > other.estimatedTotalCost){
            return 1; // the cost of current object is MORE than the parameter object
        } else {
            return 0; // if =
        }
    }
}
