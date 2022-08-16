#ifndef __VERTEX_H__
#define __VERTEX_H__

#include <string>

class Vertex {

    public:
        Vertex(std::string name, int index);

        bool was_visited();

        void visit();

        void unvisit();

        int get_index();

        void set_index(int index);

    private:
        std::string name;
        bool visited;
        int index;
};

#endif