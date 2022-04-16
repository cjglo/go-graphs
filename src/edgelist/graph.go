package edgelist

import (
	"os"
	"fmt"
	"errors"
	"bufio"
	"strings"
	"strconv"
	"math"
	"sort"
)

// === Graph as Edge List

type Graph struct {
	vertices []vertex
	edges []edge
}

type vertex struct {
	Name string
	Index int
	Visited bool
}

type edge struct {
	Weight int
	Index int
	V1 *vertex
	V2 *vertex
}

func (graph Graph) FindShortestPath(v1Name string, v2Name string) (int, error) {

	// find vertices
	v1 := graph.findVertexByName(v1Name)
	if v1 == nil {
		return 0, errors.New("v1 not found")
	}
	v2 := graph.findVertexByName(v2Name) 
	if v2 == nil {
		return 0, errors.New("v1 not found")
	}

	m := make(map[string]int) // will use prioirty queue in other versions, since edge list is already inefficient, I will focus on simple impl here
 	
	for _, vert := range(graph.vertices) {
		m[vert.Name] = math.MaxInt64
	}

	path := graph.recurseDijkstras(graph.findVertexByName(v1Name), graph.findVertexByName(v2Name), m, 0)

	// TODO: Reset all to unvisted, build helper function

	return path, nil
}

// NOTE: I have some error handling, but since this is for graph practice not to create an actual library, I am somewhat expecting "graph language" correctness
func ReadFromFile(filePath string) (Graph, error) {

	file, err := os.Open(filePath)

	if err != nil {
		fmt.Errorf("Faield to Open " + filePath)
		return Graph{}, errors.New("Failed to Open " +filePath)
	}
	defer file.Close()

	// creation of graph to return
	graph := Graph{vertices: make([]vertex, 0), edges: make([]edge, 0)}

	scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        line := scanner.Text()
		if len(line) == 0 {
			continue
		}
		words := strings.Fields(line)
		if line[0] == '-' {
			// creating edge
			// first grab weight
			weight, err := strconv.Atoi(words[1])
			if err != nil {
				fmt.Errorf("Failed to read line: " + line)
				continue
			}

			// next two words are names of Vertices
			v1 := graph.findVertexByName(words[2])
			v2 := graph.findVertexByName(words[3])
			if v1 == nil || v2 == nil {
				fmt.Errorf("Error creating Vertex. Not Found: " + words[1] + " " + words[2])
			}

			graph.edges = append(graph.edges, edge{Weight: weight, Index: len(graph.edges), V1: v1, V2: v2})

		} else if line[0] != ' ' && line[0] != '\n' {
			// creating vertex
			graph.vertices = append(graph.vertices, vertex{Name: words[0], Index: len(graph.vertices), Visited: false})
		}
    }

	fmt.Println(graph)
	return graph, nil
}

// helper functions/structs

// this struct makes Dijksra's a lot easier
type vertexPairing struct {
	Vert *vertex
	EdgeWeight int
}

func (graph Graph) recurseDijkstras(begin *vertex, end *vertex, m map[string]int, pathSum int) int {

	if begin == end {
		return m[end.Name]
	}

	begin.Visited = true

	// step 1 of dijkstra's
	m = graph.updateNeighborsDijkstras(begin, pathSum, m)

	// step 2
	neighborList := graph.createHeapOfNeighbors(begin)

	min := math.MaxInt64
	for _, neighbor := range(neighborList) {
		path := graph.recurseDijkstras(neighbor.Vert, end, m, pathSum + neighbor.EdgeWeight)
		if path < min {
			min = path
		}
	}
	return min
}

func (graph Graph) createHeapOfNeighbors(origin *vertex) []vertexPairing {

	neighborList := make([]vertexPairing, 0) // heap would be better, will likely come back to impl own heap in future

	for _, edge := range(graph.edges) {

		var pair vertexPairing

		if edge.V1 == origin && !edge.V2.Visited {
			pair = vertexPairing {
				Vert: edge.V2,
				EdgeWeight: edge.Weight,
			}
		} else if edge.V2 == origin && !edge.V1.Visited {
			pair = vertexPairing {
				Vert: edge.V1,
				EdgeWeight: edge.Weight,
			}
		}
		neighborList = append(neighborList, pair)
	}

	sort.Slice(neighborList, func(i, j int) bool {
		return neighborList[i].EdgeWeight < neighborList[j].EdgeWeight
	  })

	return neighborList
}


func (graph Graph) findVertexByName(name string) *vertex {
	for _, vert := range(graph.vertices) {
		if vert.Name == name {
			return &vert
		}
	}
	return nil
}

func (graph Graph) updateNeighborsDijkstras(vert *vertex, pathSum int, m map[string]int) map[string]int {

	weight := 0
	name := ""

	for _, edge := range(graph.edges) {

		if edge.V1 == vert {
			weight = edge.Weight
			name = edge.V2.Name
		} else if edge.V2 == vert {
			weight = edge.Weight
			name = edge.V1.Name
		}
		val, _ := m[name]
		if val > weight + pathSum {
			m[name] = weight + pathSum
		}
	}
	
	return m
}

func (graph Graph) findAllAdjacentVertices(center *vertex) []*vertex {

	vertexList := make([]*vertex, 0)

	for _, edge := range(graph.edges) {
		if edge.V1 == center {
			vertexList = append(vertexList, edge.V2)
		}
		if edge.V2 == center {
			vertexList = append(vertexList, edge.V1)
		}
	}
	
	return vertexList
}