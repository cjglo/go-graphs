#ifndef __VERTEX_H__
#define __VERTEX_H__

#include <string>

class Vertex {

    public:
        Vertex(std::string name, int index);

        void visit();

        void unvisit();

    private:
        std::string name;
        bool visited;
        int index;
};

#endif