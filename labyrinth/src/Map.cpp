#include "Map.hpp"
#include <sys/stat.h>
#include <exception>

static const char IN = 'I';
static const char EXIT = 'E';
static const char WALL = '0';

std::array<Node, 4> Map::s_dirs = {
		Node{1, 0},
		Node{0, -1},
		Node{-1, 0},
		Node{0, 1}
	};


Map::Map(std::string fileName) : map_(), width_(0), height_(0) {
	//read map and set width and height
	readFromFile(fileName);

	this->in_ = getCharPositionOnField(IN);
	this->exit_ = getCharPositionOnField(EXIT);
}

void Map::readFromFile(std::string &fileName)
{
	std::ifstream ifs (fileName, std::ifstream::in);
	{
		struct stat s{};
		if ((stat(fileName.c_str(), &s) != 0) || !(s.st_mode & S_IFREG) || !ifs.is_open())
			throw std::logic_error("Failed to open " + fileName);
	}

	std::string	line;
	int			i = 0;

	for (; std::getline(ifs, line); i++) {
		unsigned long id = 0;
		while ( (id = line.find_first_not_of("0 IE")) != std::string::npos ) {
			std::replace(line.begin(), line.end(), line[id], '0');
		}
		this->map_.push_back(line);
	}
	this->height_ = i;
	this->width_ = line.size();
}

Node Map::getCharPositionOnField(char ch) {
	for (std::size_t y = 0; y != this->map_.size(); y++) {
		for (std::size_t x = 0; x != this->map_[y].size(); x++) {
			if (this->map_[y][x] == ch) {
				return {static_cast<int>(x), static_cast<int>(y)};
			}
		}
	}
	throw std::logic_error("Character not found.");
}

bool Map::isObstacle(Node next) const {
	return (map_[next.y][next.x] != WALL);
}

bool Map::inBounds(Node next) const {
	return (next.x >= 0 && next.y >= 0) && (next.x < width_ && next.y < height_);
}

std::vector<Node> Map::reachablePaths(Node obj) const {
	std::vector<Node> res;

	for (Node dir : s_dirs) {
		Node next{obj.x + dir.x, obj.y + dir.y};
		if (inBounds(next) && isObstacle(next)) {
			res.push_back(next);
		}
	}
	return res;
}

int Map::heuristic(Node a, Node b) {
	return std::abs(a.x - b.x) + std::abs(a.y - b.y);
}

void Map::aStar () {
	priorityQueue<int, Node> front;
	front.emplace(0, this->in_);
	visited_[this->in_] = this->in_;
	nodeDistance_[this->in_] = 0;

	while (!front.empty()) {
		Node current = front.get();
		if (current == this->exit_) {
			break;
		}
		for (auto next : reachablePaths(current)) {
			int newCost = nodeDistance_[current] + 1;
			if (nodeDistance_.find(next) == nodeDistance_.end() || newCost < nodeDistance_[next]) {
				nodeDistance_[next] = newCost;
				int priority = newCost + heuristic(next, this->exit_);
				front.emplace(priority, next);
				visited_[next] = current;
			}
		}
	}
}

std::vector<Node> Map::path() {
	std::vector<Node>	path;
	Node				current = this->exit_;

	while (current != this->in_) {
		path.push_back(current);
		current = visited_[current];
	}
	return path;
}

void Map::drawSolvedMap(std::vector<Node> &path) {
	for(auto &it : path) {
		this->map_[it.y][it.x] = '.';
	}
	this->map_[exit_.y][exit_.x] = EXIT;
	for(auto &it : this->map_) {
		std::cout << it.substr(0, this->width_) << std::endl;
	}
}