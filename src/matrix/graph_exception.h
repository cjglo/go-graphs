#ifndef __GRAPH_EXCEPTION_H__
#define __GRAPH_EXCEPTION_H__

#include <string>
#include <exception>

class GraphException : public std::exception {
    private:
    std::string message;

    public:
    GraphException(std::string msg);
    std::string what();
};

#endif