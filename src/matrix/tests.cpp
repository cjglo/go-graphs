#include "tests.h"

using namespace std; // just for ease of testing

int main() {


    Graph graph;
    string file = "example_graph.txt";
    graph.read_from_file(file);

    return 0;
}