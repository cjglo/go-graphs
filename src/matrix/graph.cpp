#include "graph.h"
using std::vector;
using std::string;
using std::ifstream;
using std::map;

Graph::Graph() {
    this->adj_matrix = nullptr;
}

void Graph::read_from_file(string file_name) {

    ifstream graph_file(file_name);
    string line;
    if(graph_file.is_open()) {

        int vertex_counter = 0;
        map<string, Vertex*> m;
        bool no_edge_yet = true;

        while(getline(graph_file,line)) {
            
            if(line.size() == 0) continue;
            
            if(line[0] != '-') {
                // Vertex found and needs to be made
                vertex_counter++;
                Vertex* vert = new Vertex(line, vertex_counter);
                m[line] = vert;
            }
            else if(no_edge_yet && line[0] == '-') {
                no_edge_yet = false;
                // constructing matrix before processing edges
                this->adj_matrix = new int*[vertex_counter];
                for(int i = 0; i<vertex_counter; i++) {
                    adj_matrix[i] = new int[vertex_counter];
                }
                for(auto row : adj_matrix) {
                    for(auto cell : row) {
                        cell = nullptr;
                    }
                }
            }

            if(line[0] == '-') {
                // TODO make edges
            }



        }
    } else {
        std::cout<< "Error Reading File" <<std::endl; // TODO: Create wrapper or exception
    }
        

}

/*
read file steps"
1. count up vertexes => as count make vertex, give index and put in map <name, ptr>\
2. Once total number found, build matrix and fill with null_ptrs
3. Build edge with weight, use names to assign pointers, place it in array where indexes meet

*/