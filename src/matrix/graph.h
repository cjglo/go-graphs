#ifndef __GRAPHS_H_
#define __GRAPHS_H_

#include <vector>
#include <fstream>
#include <iostream>
#include <string>

class Graph {
    public:
        Graph();
        void read_from_file(std::string file_name);

        
    private:
        std::vector<std::vector<bool>> adj_matrix;
        
};

#endif