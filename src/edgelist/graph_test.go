package edgelist


import (
	// "fmt"
	"testing"
	"strconv"
)




func TestInitGraph(t *testing.T) {
    
	_, err := ReadFromFile("example_graph.txt")
	if err != nil {
		t.Errorf("Failed to initialize graph: " + err.Error())
	}
}


func TestShortestPath(t* testing.T) {

	graph, err := ReadFromFile("example_graph.txt")
	if err != nil {
		t.Errorf("Failed to initialize graph: " + err.Error())
	}

	lengthOfPath1, err1 := graph.FindShortestPath("a", "g")

	if err1 != nil {
		t.Errorf("Failed: " + err1.Error())
	}

	lengthOfPath2, err2 := graph.FindShortestPath("f", "d")

	if err2 != nil {
		t.Errorf("Failed: " + err2.Error())
	}

	// actual testing of if is shortest path
	if lengthOfPath1 != 15 {
		t.Errorf("Failed: Path 1 expect to be 15 but got: " + strconv.Itoa(lengthOfPath1))
	}
	if lengthOfPath2 != 17 {
		t.Errorf("Failed: Path 2 expect to be 17 but got: " + strconv.Itoa(lengthOfPath2))
	}
}