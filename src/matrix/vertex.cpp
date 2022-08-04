#include "vertex.h"

using std::string;

Vertex::Vertex(string name, int index) {
    this->name = name;
    this->index = index;
    this->visited = false;
}

void Vertex::visit() {
    this->visited = true;
}

void Vertex::unvisit() {
    this->visited = false;
}