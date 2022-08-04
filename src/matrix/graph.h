#ifndef __GRAPHS_H_
#define __GRAPHS_H_

#include <vector>
#include <fstream>
#include <iostream>
#include <string>
#include <map>
#include "edge.h"

class Graph {
    public:
        Graph();
        void read_from_file(std::string file_name);
        
    private:
        Edge*** adj_matrix;
        
};

#endif