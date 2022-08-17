#include "tests.h"

using namespace std; // just for ease of testing

// UNIT TESTING:

void test_graph_init()
{
    Graph graph;
    string file = "example_graph.txt";
    graph.read_from_file(file);
    IS_TRUE(!graph.is_empty());
}

void test_shortest_path_a_to_g()
{
    const int DISTANCE_A_TO_G = 15;
    Graph graph;
    string file = "example_graph.txt";
    graph.read_from_file(file);
    int dist = graph.find_shortest_path("a", "g"); // 15
    IS_TRUE(dist == DISTANCE_A_TO_G);
}

void test_shortest_path_f_to_d()
{
    const int DISTANCE_F_TO_D = 17;
    Graph graph;
    string file = "example_graph.txt";
    graph.read_from_file(file);
    int dist = graph.find_shortest_path("f", "d"); // 15
    IS_TRUE(dist == DISTANCE_F_TO_D);
}

void test_find_c_exists_in_graph()
{
    Graph graph;
    string file = "example_graph.txt";
    graph.read_from_file(file);
    IS_TRUE(graph.does_vertex_exist_in_graph("c"));
}

void test_find_z_does_not_exist_in_graph()
{
    Graph graph;
    string file = "example_graph.txt";
    graph.read_from_file(file);
    IS_TRUE(!graph.does_vertex_exist_in_graph("z"));
}


int main() {

    // tests
    test_graph_init();
    test_shortest_path_a_to_g();
    test_shortest_path_f_to_d();
    test_find_c_exists_in_graph();
    test_find_z_does_not_exist_in_graph();

    return 0;
}