#ifndef __GRAPHS_H_
#define __GRAPHS_H_

#include <vector>
#include <fstream>
#include <iostream>
#include <string>
#include <map>
#include <exception>

#include "edge.h"
#include "vertex.h"
#include <bits/stdc++.h>

// min heap based on distance (int)
typedef std::pair<int,Vertex*> distance_and_vert;
typedef std::priority_queue<distance_and_vert, std::vector<distance_and_vert>, std::greater<distance_and_vert>> heap;

class Graph {
    public:
        Graph();
        Graph(std::string file_name);
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

// Graph Exeception class
class GraphException : public std::exception {
    private:
    std::string message;

    public:
    GraphException(std::string msg);
    std::string what ();
};

#endif