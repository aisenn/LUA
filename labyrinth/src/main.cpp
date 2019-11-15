#include <iostream>
#include "Map.hpp"

int main(int argc, char** argv) {
	if (argc > 1) {
		try {
			Map map(argv[1]);

			map.aStar();
			std::vector<Node> path = map.path();
			map.drawSolvedMap(path);
		} catch (std::exception &e) {
			std::cout << e.what() << std::endl;
		}
	}
	else 
		std::cout << "Choose a file with maze" << std::endl;
	return 0;
}
