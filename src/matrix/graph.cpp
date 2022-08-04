#include "graph.h"
using std::vector;
using std::string;
using std::ifstream;
using std::map;

Graph::Graph() : vert_name_to_ptr() {
    this->adj_matrix = nullptr;
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
                    // TODO Parser here is pretty messy, may want to rewrite
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
    } else {
        std::cout<< "Error Reading File" <<std::endl; // TODO: Create wrapper or exception
    }
}

int Graph::find_shortest_path(string v1_name, string v2_name) {

    if(vert_name_to_ptr.find(v1_name) == vert_name_to_ptr.end() 
        || vert_name_to_ptr.find(v2_name) == vert_name_to_ptr.end()) {
        // error handling for if either name does not exist, could make exception class
        return -1;
    }

    Vertex* vert1 = vert_name_to_ptr[v1_name];
    Vertex* vert2 = vert_name_to_ptr[v2_name];

    // TODO continue here


}


// Private Methods Implementations

