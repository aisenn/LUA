#include "Node.hpp"

bool Node::operator != (Node rhs) {
	return !(*this == rhs);
}

bool Node::operator == (Node rhs) {
	return this->x == rhs.x && this->y == rhs.y;
}

bool operator < (Node lhs, Node rhs) {
  return std::tie(lhs.x, lhs.y) < std::tie(rhs.x, rhs.y);
}