#include "graph.h"
using std::vector;
using std::string;
using std::ifstream;

Graph::Graph(): adj_matrix() {}

void Graph::read_from_file(string file_name) {

    ifstream graph_file(file_name);
    string line;
    if(graph_file.is_open()) {
        while(getline(graph_file,line)) {
            std::cout<<line<<std::endl;
        }
    } else {
        std::cout<< "Error Reading File" <<std::endl; // TODO: Create wrapper or exception
    }
        

}