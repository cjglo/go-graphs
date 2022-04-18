# Graphs

My library for creating various Graph implementations.  No resources used for this other than by old C++ data structures book to remember how to build and the png `Graph` as a starting point for the Graph.

## Tools

I decided to mix up the langauges to keep things interesting. So far:

1. Edge List Implementation -> Go
2. Adjacency List Implementation -> Zig 
3. Matrix Implementation -> TBD (Leaning towards C++ or Go)

### Properties

`Graph.png` will be the graph implemented (may add a few vertices to vary the graphs of each implementation).  All Graphs are weighted and undirectional.

Each Graph will implement:
-- Public Methods
1. ReadFromFile -> Algorithm to read in custom graph language (below) and create graph
2. FindShortestPath -> Shortest path from a two given Vertices (Dijkstra's)
3. DoesNameExistInGraph -> Return true if a name matches the name of any vertex, else return false

The read algorithm that will create graph from text will work like this: (anything after // is comment about line)

```
a // first lists Vertices, these are just the names of the Vertex
b // NOTE: we use these names as identifiers, so they must be unqiue
c
d

- 5 a b // next is edges, starting with '-' and followed by edge weight then the 2 Vertexes.  NOTE: Since I made this undirectional, order of Vertices is irrelavant
- 1 b c 
- 3 a c
- 4 d b
```

The above will create a graph with 4 Vertices (a, b, c and d) with connections between a & b (weight 5), b & c (weight 1), a & c (weight 3), and d & b (weight 4)