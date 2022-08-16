#ifndef __GRAPHS_H_
#define __GRAPHS_H_

#include <vector>
#include <fstream>
#include <iostream>
#include <string>
#include <map>
#include "edge.h"
#include "vertex.h"
#include <bits/stdc++.h>

class Graph {
    public:
        Graph();
        void read_from_file(std::string file_name);
        int find_shortest_path(std::string v1_name, std::string v2_name);
        
        
    private:
        int dijkstras(Vertex* begin, Vertex* end, std::map<Vertex*,int> &m, int path);
        void update_neighbors(Vertex* current, map<Vertex*,int> m, int path);
        Edge*** adj_matrix;
        std::map<std::string, Vertex*> vert_name_to_ptr;
        int num_of_vertices;
};

#endif