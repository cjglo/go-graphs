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

typedef std::priority_queue<std::pair<int,Vertex*>, std::vector<std::pair<int,Vertex*>>, std::greater<std::pair<int,Vertex*>>> heap;

class Graph {
    public:
        Graph();
        void read_from_file(std::string file_name);
        int find_shortest_path(std::string v1_name, std::string v2_name);
        bool does_vertex_exist_in_graph(std::string vertex_name);
        bool is_empty();
        
        
    private:
        Edge*** adj_matrix;
        std::map<std::string, Vertex*> vert_name_to_ptr;
        int num_of_vertices;

        int dijkstras(Vertex* begin, Vertex* end, std::map<Vertex*,int> &m, int path);
        void update_neighbors(Vertex* current, std::map<Vertex*,int> &m, int path);
        heap create_neighbors_min_heap(Vertex* current);
        
};

#endif