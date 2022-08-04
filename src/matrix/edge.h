#ifndef __EDGE_H__
#define __EDGE_H__

#include "vertex.h"

class Edge {

    Edge(int weight, Vertex* v1, Vertex* v2);

    public:
        int get_weight();

        int set_weight(int weight);

        Vertex* get_v1();

        Vertex* get_v2();

        void set_v1(Vertex* ptr);

        void set_v2(Vertex* ptr);

    private:
        int weight;
        Vertex* v1;
        Vertex* v2;
};

#endif