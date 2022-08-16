#include "vertex.h"

using std::string;

Vertex::Vertex(string name, int index) {
    this->name = name;
    this->index = index;
    this->visited = false;
}

bool Vertex::was_visited() {
    return this->visited;
}

void Vertex::visit() {
    this->visited = true;
}

void Vertex::unvisit() {
    this->visited = false;
}

int Vertex::get_index() {
    return this->index;
}

void Vertex::set_index(int index) {
    this->index = index;
}