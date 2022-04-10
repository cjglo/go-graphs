package edgelist

// Graph as Edge List

import (
	"os"
	"fmt"
	"errors"
	"bufio"
	"strings"
	"strconv"
)


type Graph struct {
	vertices []vertex
	edges []edge
}

type vertex struct {
	Name string
	Index int
}

type edge struct {
	Weight int
	Index int
	V1 *vertex
	V2 *vertex
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
			graph.vertices = append(graph.vertices, vertex{Name: words[0], Index: len(graph.vertices)})
		}
    }

	fmt.Println(graph)
	return graph, nil
}


func (graph Graph) findVertexByName(name string) *vertex {
	for _, vert := range(graph.vertices) {
		if vert.Name == name {
			return &vert
		}
	}
	return nil
}