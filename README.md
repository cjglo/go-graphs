# Go Graphs

My library for creating various Graph implementations.  No resources used for this other than by old C++ data structures book to remember how to build.


### Graphs

Each directory has image of graph that was used for implementation.  All Graphs are weighted and undirectional.

Each Graph will implement:
1. Algorithm to read in custom graph language (below) and create graph
2. Shortest path from a two given Vertices
3. Search and return Vertex if exists
-- Private Methods
4. delete Vertex
5. delete Edge
6. add Vertex (with 1 parameter: value)
7. add Edge (with 2 paramters: Two Vertices it is between)


Also will implement a read algorithm that will create graph from text I make.  Text will work like this: (anything after // is comment about line)

```
a // first lists Vertices, these are just the names of the Vertex
b // NOTE: we use these names as indenfifiers, so they must be unqiue
c
d

- 5 a b // next is edges, starting with '-' and followed by edge weight then the 2 Vertexes.  NOTE: Since I made this undirectional, order of Vertices is irrelavant
- 1 b c 
- 3 a c
- 4 d b
```

The above will create a graph with 4 Vertices (a, b, c and d) with connections between a & b (weight 5), b & c (weight 1), a & c (weight 3), and d & b (weight 4)