#include "tests.h"

using namespace std; // just for ease of testing

int main() {

    // TODO: More professional testing suite

    // Testing Graph intialization
    Graph graph;
    string file = "example_graph.txt";
    graph.read_from_file(file);

    // testing Shortest Path
    int dist = graph.find_shortest_path("a", "g"); // 15
    cout<<dist<<endl;
    dist = graph.find_shortest_path("f", "d"); // 17
    cout<<dist<<endl;

    return 0;
}