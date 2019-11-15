#ifndef MAP_HPP
#define MAP_HPP

#include <fstream>
#include <array>
#include <iostream>
#include <vector>
#include <queue>
#include <map>

#include "Node.hpp"

template<typename P, typename T>
struct priorityQueue
		: std::priority_queue<std::pair<P, T>,
							  std::vector<std::pair<P, T>>,
							  std::greater<std::pair<P, T>>>
{
	T get() {
		T tmp = this->top().second;
		this->pop();
		return tmp;
	}
};

class Map
{
private:
	static std::array<Node, 4>	s_dirs;
	std::vector<std::string>	map_;
	int							width_;
	int							height_;
	Node						in_;
	Node						exit_;
	std::map<Node, Node>		visited_;
	std::map<Node, int>			nodeDistance_;

public:
	Map(std::string fileName);

	void				readFromFile(std::string &fileName);
	Node				getCharPositionOnField(char ch);

	bool				isObstacle(Node next) const;
	bool				inBounds(Node next) const;
	std::vector<Node>	reachablePaths(Node obj) const;
	static int			heuristic(Node a, Node b);

	void				aStar();
	std::vector<Node>	path();
	void				drawSolvedMap(std::vector<Node> &path);
};

#endif //MAP_HPP
