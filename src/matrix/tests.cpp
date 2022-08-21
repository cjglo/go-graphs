#include "tests.h"

using namespace std; // just for ease of testing

// UNIT TESTING:

void test_graph_init()
{
    Graph graph;
    string file = "example_graph.txt";
    graph.read_from_file(file);

    Graph graph2("example_graph.txt");

    IS_TRUE(!graph.is_empty() && !graph2.is_empty());
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
    int dist = graph.find_shortest_path("f", "d"); // 17

    IS_TRUE(dist == DISTANCE_F_TO_D);
}

void test_shortest_path_e_to_e()
{
    const int DISTANCE_E_TO_E = 0;
    Graph graph;
    string file = "example_graph.txt";
    graph.read_from_file(file);
    int dist = graph.find_shortest_path("e", "e"); // 0

    IS_TRUE(dist == DISTANCE_E_TO_E);
}

void test_find_c_exists_in_graph()
{
    Graph graph;
    string file = "example_graph.txt";
    graph.read_from_file(file);

    Graph graph2("example_graph.txt");

    IS_TRUE(graph.does_vertex_exist_in_graph("c") && graph2.does_vertex_exist_in_graph("c"));
}

void test_find_z_does_not_exist_in_graph()
{
    Graph graph;
    string file = "example_graph.txt";
    graph.read_from_file(file);

    Graph graph2("example_graph.txt");

    IS_TRUE(!graph.does_vertex_exist_in_graph("z") && !graph2.does_vertex_exist_in_graph("z"));
}


int main() {

    // tests
    test_graph_init();
    test_shortest_path_a_to_g();
    test_shortest_path_f_to_d();
    test_shortest_path_e_to_e();
    test_find_c_exists_in_graph();
    test_find_z_does_not_exist_in_graph();

    return 0;
}
