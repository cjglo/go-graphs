#ifndef __GRAPHS_H_
#define __GRAPHS_H_

#include <vector>
#include <fstream>
#include <iostream>
#include <string>
#include <map>
#include "edge.h"
#include "vertex.h"

class Graph {
    public:
        Graph();
        void read_from_file(std::string file_name);
        int find_shortest_path(std::string v1_name, std::string v2_name);
        
    private:
        Edge*** adj_matrix;
        std::map<std::string, Vertex*> vert_name_to_ptr;
};

#endif