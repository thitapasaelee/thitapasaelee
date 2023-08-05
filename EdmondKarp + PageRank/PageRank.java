import javafx.util.Pair;

import java.util.*;

/**
 * Write a description of class PageRank here.
 *
 * @author (your name)
 * @version (a version number or a date)
 */
public class PageRank
{
    //class members 
    private static double dampingFactor = .85;
    private static int iter = 10;
    /**
     * build the fromLinks and toLinks 
     */
    //TODO: Build the data structure to support Page rank. For each edge in the graph add the corresponding cities to the fromLinks and toLinks
    public static void computeLinks(Graph graph){
        // TODO
        for(Edge edge : graph.getOriginalEdges()){
            // get the edges
            City fromCity = edge.fromCity();
            City toCity = edge.toCity();
            
            // link the edges
            fromCity.addToLinks(toCity);
            toCity.addFromLinks(fromCity);
        }
        //printPageRankGraphData(graph);  ////may help in debugging
        // END TODO
    }

    public static void printPageRankGraphData(Graph graph){
        System.out.println("\nPage Rank Graph");

        for (City city : graph.getCities().values()){
            System.out.print("\nCity: "+city.toString());
            //for each city display the in edges 
            System.out.print("\nIn links to cities:");
            for(City c:city.getFromLinks()){

                System.out.print("["+c.getId()+"] ");
            }

            System.out.print("\nOut links to cities:");
            //for each city display the out edges 
            for(City c: city.getToLinks()){
                System.out.print("["+c.getId()+"] ");
            }
            System.out.println();;

        }    
        System.out.println("=================");
    }
    //TODO: Compute rank of all nodes in the network and display them at the console
    public static void computePageRank(Graph graph){
        // TODO
        Map<City, Double> pageRank = new HashMap<>();

        // initialise the page rank
        for (City city : graph.getCities().values()){
            pageRank.put(city, 1.0); // initialise pagerank
        }

        // calculate N
        int N = graph.getCities().size();

        // page rank calculation
        for(int i = 0; i < iter; i++) {
            Map<City, Double> newPageRank = new HashMap<>(); // double = rank value
            
            // loop through  and get value of the cities
            for (City city : graph.getCities().values()){
                double sum = 0.0; // set it as 0 first
                for(City inLink : city.getFromLinks()){
                    sum += pageRank.get(inLink) / inLink.getToLinks().size(); // inlink/its size
                }
                newPageRank.put(city, ((1 - dampingFactor)/N) + dampingFactor * sum); // formula
            }

            pageRank = newPageRank;
        }

        // convert the page rank MAP to LIST
        List<Pair<City, Double>> pageRankList = new ArrayList<>();
        for (Map.Entry<City, Double> entry : pageRank.entrySet()){
            pageRankList.add(new Pair<>(entry.getKey(), entry.getValue()));
        }

        // // sort the list based on the page rank values from the highest to lowest
        // Collections.sort(pageRankList, new Comparator<Pair<City, Double>>(){
            // public int compare(Pair<City, Double> a, Pair<City, Double> b){
                // return Double.compare(b.getValue(), a.getValue());
            // }
        // });

        // print the page rank of each city
        for (City city : graph.getCities().values()){
            System.out.println(city.getName() + ": "+ pageRank.get(city));
        }
        // END TODO
    }
}
