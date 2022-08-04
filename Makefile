ROOT_TO_SOURCE_FILES := src/matrix/tests.cpp src/matrix/graph.cpp src/matrix/vertex.cpp src/matrix/edge.cpp
SOURCE_FILES := tests.cpp graph.cpp vertex.cpp edge.cpp

build: ${ROOT_TO_SOURCE_FILES}
	cd src/matrix && g++ ${SOURCE_FILES} 

run: src/matrix/a.out
	cd src/matrix && ./a.out

clean:
	rm src/matrix/a.out
