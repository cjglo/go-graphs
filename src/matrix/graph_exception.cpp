#include "graph_exception.h"

using std::string;

GraphException::GraphException(string msg) {
    this->message = msg;
}

string GraphException::what () {
    return this->message;
}
