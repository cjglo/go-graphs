#include "edge.h"

Edge::Edge(int weight, Vertex* v1, Vertex* v2) {
    this->weight = weight;
    this->v1 = v1;
    this->v2 = v2;
}


int Edge::get_weight() {
    return this->weight;
}

int Edge::set_weight(int weight) {
    this->weight = weight;
}

Vertex* Edge::get_v1() {
    return this->v1;
}

Vertex* Edge::get_v2() {
    return this->v2;
}

void Edge::set_v1(Vertex* ptr) {
    this->v1 = ptr;
}

void Edge::set_v2(Vertex* ptr) {
    this->v2 = ptr;
}