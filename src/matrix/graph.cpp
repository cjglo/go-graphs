#include "graph.h"
using std::vector;
using std::string;
using std::ifstream;
using std::map;
using std::priority_queue;
using std::pair;

GraphException::GraphException(string msg) {
    this->message = msg;
}

string GraphException::what () {
    return this->message;
}

Graph::Graph() : vert_name_to_ptr() {
    this->adj_matrix = nullptr;
    this->num_of_vertices = 0;
}

void Graph::read_from_file(string file_name) {

    ifstream graph_file(file_name);
    string line;
    if(graph_file.is_open()) {

        int vertex_counter = 0;
        bool no_edge_yet = true;

        while(getline(graph_file,line)) {
            
            if(line.size() == 0) continue;
            
            if(line[0] != '-') {
                // Vertex found and needs to be made
                Vertex* vert = new Vertex(line, vertex_counter);
                vert_name_to_ptr[line] = vert;
                vertex_counter++;
            }
            else if(no_edge_yet && line[0] == '-') {
                no_edge_yet = false;
                // constructing matrix before processing edges
                this->adj_matrix = new Edge**[vertex_counter];

                for(int i = 0; i<vertex_counter; i++) {
                    adj_matrix[i] = new Edge*[vertex_counter];
                }
                for(int i = 0; i<vertex_counter; i++) {
                    for(int j = 0; j<vertex_counter; j++) {
                        adj_matrix[i][j] = nullptr;
                    }
                }
            }

            if(line[0] == '-') {
                int weight = 0;
                string v1_name = "";
                bool v1_done = false;
                string v2_name = "";

                for(auto letter : line) {
                    // NOTE: Since excerise is about graph practice and not error handling, parser assumes correct input
                    if(letter == '-') continue;

                    if(letter >= '0' && letter <= '9') {
                        weight *= 10; // move num over digits insert next digit
                        weight += letter - '0';
                    } else if(letter == ' ' && v1_name.size() > 0) {
                        v1_done = true;
                    } else if(letter != '-' && letter != ' ') {
                        if(v1_done) v2_name += letter;
                        else v1_name += letter;
                    }
                }
                Vertex* v1 = vert_name_to_ptr[v1_name];
                Vertex* v2 = vert_name_to_ptr[v2_name];

                Edge* edge = new Edge(weight, v1, v2);

                int i = v1->get_index();
                int j = v2->get_index();  

                adj_matrix[i][j] = edge;
                adj_matrix[j][i] = edge;
            }
        }

        this->num_of_vertices = vertex_counter;
    } else {
        throw GraphException("Error Reading File");
    }
}

Graph::Graph(string file_name) : vert_name_to_ptr() {
    this->adj_matrix = nullptr;
    this->num_of_vertices = 0;
    this->read_from_file(file_name);
}

int Graph::find_shortest_path(string v1_name, string v2_name) {
    // error handling for vertices not existing
    if(vert_name_to_ptr.find(v1_name) == vert_name_to_ptr.end()) {
        throw GraphException("Vertex " + v1_name + " does not exist in graph");
    }
    if(vert_name_to_ptr.find(v2_name) == vert_name_to_ptr.end()) {
        throw GraphException("Vertex " + v2_name + " does not exist in graph");
    }

    Vertex* vert1 = vert_name_to_ptr[v1_name];
    Vertex* vert2 = vert_name_to_ptr[v2_name];

    map<Vertex*, int> m;

    for(auto pair : this->vert_name_to_ptr) {
        m[pair.second] = INT_MAX;
    }

    int dist = this->dijkstras(vert1, vert2, m, 0);

    for(auto pair : m) {
        pair.first->unvisit();
    }

    return dist;
}

bool Graph::does_vertex_exist_in_graph(string vertex_name) {
    if(this->vert_name_to_ptr.find(vertex_name) != this->vert_name_to_ptr.end()) {
        return true;
    } else {
        return false;
    }
}

bool Graph::is_empty() {
    if(this->num_of_vertices < 0) {
        return true;
    } else {
        return false;
    }
}

// Private Methods Implementations

int Graph::dijkstras(Vertex* begin, Vertex* end, map<Vertex*,int> &m, int path) {
    if(begin == end) {
        return m[begin];
    }

    begin->visit();

    // Step 1 - update neighbors
    update_neighbors(begin, m, path);

    // Step 2 - Create min heap of neighbors and go to closest neighbor
    heap hp = create_neighbors_min_heap(begin);

    int distance = INT_MAX;
    while(!hp.empty()) {

        Vertex* next = hp.top().second;
        int weight = hp.top().first;
        hp.pop();
        distance = std::min(distance, this->dijkstras(next, end, m, path + weight));
    }
    return distance;
}

void Graph::update_neighbors(Vertex* current, map<Vertex*,int> &m, int path) {

    for(int i = 0; i<this->num_of_vertices; i++) {

        if(this->adj_matrix[current->get_index()][i] != nullptr) {

            Edge* edge = this->adj_matrix[current->get_index()][i];

            int weight = edge->get_weight();

            if(edge->get_v1() != current) {
                m[edge->get_v1()] = std::min(m[edge->get_v1()], path + weight);
            } 
            else if(edge->get_v2() != current) {
                m[edge->get_v2()] = std::min(m[edge->get_v2()], path + weight);
            }
        }
    }
}

heap Graph::create_neighbors_min_heap(Vertex* current) {

    heap hp;

    for(int i = 0; i<this->num_of_vertices; i++) {

        if(this->adj_matrix[current->get_index()][i] != nullptr) {

            Edge* edge = this->adj_matrix[current->get_index()][i];

            if(edge->get_v1() != current && !edge->get_v1()->was_visited()) {
                hp.push(std::make_pair(edge->get_weight(), edge->get_v1()));
            }
            else if(edge->get_v2() != current && !edge->get_v2()->was_visited()) {
                hp.push(std::make_pair(edge->get_weight(), edge->get_v2()));
            }

        }

    }

    return hp;
}
